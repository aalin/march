require 'rubygems'
require 'march'
require 'midiator'
require 'open3'

class MidiInput
  def initialize
    @events = []
    @events_mutex = Mutex.new
  end

  def get_events!
    @events_mutex.synchronize do
      @events.dup.tap do
        @events.clear
      end
    end
  end

  def run!
    executable = File.join(File.dirname(__FILE__), 'midi_input', 'midi_input')

    unless File.exists?(executable)
      raise "Make sure you have compiled #{executable}. Try: cd #{ File.dirname(executable) } && make"
    end

    unless File.stat(executable).executable?
      raise "#{ executable } exists, but has the wrong permissions. Try: chmod +x #{ executable }"
    end

    Thread.new do
      Open3.popen3(executable) do |stdin, stdout, stderr|
        pick_midi_source(stdin, stdout)
        loop do
          line = stdout.gets
          case line
          when /^Using source/
            puts line
          else
            add_event(line.split.map(&:to_i))
          end
        end
      end
    end
  end

  private

  def pick_midi_source(stdin, stdout)
    loop do
      line = stdout.gets
      case line
      when /^Choose sources, end with EOF:/
        print "Choose sources, separated by whitespace: "
        $stdout.flush
        stdin.puts(gets.scan(/\d+/))
        stdin.close
        break
      else
        puts line
      end
    end
  end

  def add_event(event)
    @events_mutex.synchronize do
      @events << event
    end
  end
end

if __FILE__ == $0
  class MidiInterface
    def initialize(channel)
      @channel = channel

      @midi = MIDIator::Interface.new
      @midi.use(:core_midi)

      @notes = Hash.new { |hash, key| hash[key] = 0 }
    end

    def trigger(events)
      events.each do |event|
        trigger_event(event)
      end
    end

    private

    def trigger_event(event)
      return unless event[0] == 0x90 # Channel 1 note on

      if event[2].zero?
        note_off(event[1])
      else
        note_on(event[1], event[2])
      end
    end

    def note_on(note, velocity)
      puts "\e[32m#{ March::Note.new(note) }\e[0m"
      if @notes[note].zero?
        @midi.driver.note_on(note, @channel, velocity)
      end
      @notes[note] += 1
    end

    def note_off(note)
      @notes[note] -= 1
      if @notes[note].zero?
        puts "\e[31m#{ March::Note.new(note) }\e[0m"
        @midi.driver.note_off(note, @channel)
      end
    end
  end

  require 'event_filters'

  mode = March::Mode.new(March::Note.from_name('C'), March::Scale.phrygian_dominant)

  midi_interface = MidiInterface.new(0)
  midi_input = MidiInput.new
  midi_input.run!

  filters = [
    EventFilters::WhiteKeyFilter.new(mode),    # Play any scale as if it was C major.
    # EventFilters::ArpeggioFilter.new,          # Arpeggio!
    # EventFilters::ClosestNoteFilter.new(mode), # Useful for not playing the "wrong" notes.
    # EventFilters::OnlyInModeFilter.new(mode),  # Useful for practicing scales
    # EventFilters::ChordmakerFilter.new(mode)   # Make triad chords.
  ]

  loop do
    events = midi_input.get_events!
    puts events.map { |event| event.map { |i| format("%02x", i) }.join(" ") }

    events = filters.inject(events) { |e, filter| filter.filter(e) }
    midi_interface.trigger(events)
  end
end
