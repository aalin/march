require 'rubygems'
require 'march'
require 'midiator'
require 'open3'

class MidiInput
  def run
    executable = File.join(File.dirname(__FILE__), 'midi_input', 'midi_input')

    unless File.exists?(executable)
      raise "Make sure you have compiled #{executable}. Try: cd #{ File.dirname(executable) } && make"
    end

    unless File.stat(executable).executable?
      raise "#{ executable } exists, but has the wrong permissions. Try: chmod +x #{ executable }"
    end

    Open3.popen3(executable) do |stdin, stdout, stderr|
      pick_midi_source(stdin, stdout)
      loop do
        yield stdout.gets.split.map { |s| s.to_i }
      end
    end
  end

  private

  def pick_midi_source(stdin, stdout)
    loop do
      line = stdout.gets
      case line
      when /^Choose source:/
        print "Choose source: "
        $stdout.flush
        stdin.puts(gets)
      when /^Using source (\d+)/
        puts "Using source #$1"
        break
      else
        puts line
      end
    end
  end
end

class MidiNoteTrigger
  def initialize(channel)
    @channel = channel

    @midi = MIDIator::Interface.new
    @midi.autodetect_driver

    @notes = Hash.new { |hash, key| hash[key] = 0 }
  end

  def note_on(note, velocity)
    if @notes[note] == 0
      @midi.driver.note_on(note, @channel, velocity)
    end
    @notes[note] += 1
  end

  def note_off(note)
    @notes[note] -= 1
    if @notes[note] == 0
      @midi.driver.note_off(note, @channel)
    end
  end
end

def play_closest_note(midi_note_triggerer, event, mode)
  return unless event[0] == 144

  given_note = March::Note.new(event[1])
  note = mode.closest_note(given_note.value)

  velocity = event[2]

  if note.value != given_note.value
    puts "\e[33m#{ given_note } -> #{ note }\e[0m"
  end

  if velocity.zero?
    puts "\e[31m%s\e[0m" % note.to_s
    midi_note_triggerer.note_off(note.value)
  else
    puts "\e[32m%s\e[0m" % note.to_s
    midi_note_triggerer.note_on(note.value, velocity)
  end
end

def play_if_in_mode(midi_note_triggerer, event, mode)
  return unless event[0] == 144

  note = March::Note.new(event[1])
  velocity = event[2]

  if mode.include?(note)
    if velocity.zero?
      puts "\e[31m%s\e[0m" % note.to_s
      midi_note_triggerer.note_off(note.value)
    else
      puts "\e[32m%s\e[0m" % note.to_s
      midi_note_triggerer.note_on(note.value, velocity)
    end
  else
    puts "\e[33m%s\e[0m" % note.to_s
  end
end

def play_chord(midi_note_triggerer, event, mode)
  return unless event[0] == 144

  chord_root = March::Note.new(event[1])
  velocity = event[2]

  notes = mode.triad_for_note(chord_root)

  puts "\e[%dm%s\e[0m" % [velocity.zero? ? 31 : 32, notes.join(", ")]

  if velocity.zero?
    notes.each { |note| midi_note_triggerer.note_off(note.value) }
  else
    notes.each { |note| midi_note_triggerer.note_on(note.value, velocity + rand(velocity / 10)) }
  end
end

mode = March::Mode.new(March::Note.from_name('C'), March::Scale.major)

midi_note_triggerer = MidiNoteTrigger.new(0)

MidiInput.new.run do |event|
  play_closest_note(midi_note_triggerer, event, mode) # Useful for not playing the "wrong" notes
  # play_if_in_mode(midi_note_triggerer, event, mode) # Useful for practicing scales
  # play_chord(midi_note_triggerer, event, mode)
end
