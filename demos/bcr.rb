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

class MidiInterface
  def initialize
    @midi = MIDIator::Interface.new
    @midi.autodetect_driver

    @notes = Hash.new { |hash, key| hash[key] = 0 }
  end

  def trigger(events)
    events.each do |event|
      trigger_event(event)
    end
  end

  private

  def trigger_event(event)
    if event[0] & 0xf0 == 0x90 # Note on
      channel = event[0] & 0x0f
      if event[2].zero?
        note_off(event[1], channel)
      else
        note_on(event[1], channel, event[2])
      end
    else
      puts "Message: #{ event.map { |i| format("%02x", i) }.join(" ") }"
      @midi.driver.send(:message, *event)
    end
  end

  def note_on(note, channel, velocity)
    puts "\e[32m#{ March::Note.new(note) }\e[0m #{ channel }"
    if @notes[note].zero?
      @midi.driver.note_on(note, channel, velocity)
    end
    @notes[note] += 1
  end

  def note_off(note, channel)
    @notes[note] -= 1
    if @notes[note].zero?
      puts "\e[31m#{ March::Note.new(note) }\e[0m #{ channel }"
      @midi.driver.note_off(note, channel)
    end
  end
end

mode = March::Mode.new(March::Note.from_name('C'), March::Scale.phrygian_dominant)

midi_interface = MidiInterface.new
midi_input = MidiInput.new
midi_input.run!

last_play = 0.0

bcr_table = {}

previous_notes = []
previous_root_note = nil

loop do
  events = midi_input.get_events!

  events.each do |status, knob, value|
    bcr_table[knob] = value / 127.0 # So that the scale will be 0.0..1.0
  end

  unless events.empty?
    puts bcr_table.sort_by { |k, v| k }.map { |k, v| format("0x%02x %.2f", k, v) }.join(", ")
  end

  root_degree = (bcr_table[0x61].to_f * (mode.scale.values.size.succ * 2)).to_i

  root_note = mode.at(root_degree).octave_up(3)
  unless root_note == previous_root_note
    puts "Root note: #{ root_note }, degree: #{ root_degree }"
    previous_root_note = root_note
  end

  now = Time.now.to_f
  if now - last_play > 1.0
    notes = mode.triad_for_note(root_note)

    unless previous_notes == notes.map(&:value).sort
      midi_interface.trigger(previous_notes.map { |value| [0x90, value, 0] })
      previous_notes = notes.map(&:value).sort
    end

    generated_events = notes.map { |note| [0x90, note.value, 100] }
    midi_interface.trigger(generated_events)

    last_play = now
  end
end
