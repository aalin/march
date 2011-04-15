#!/usr/bin/env

require 'rubygems'
require 'march'
require 'midiator'

class Melodizer
  def initialize(mode, octave, melody)
    @mode = mode
    @octave = octave
    @melody = melody

    @degree = 0
    @i = 0
  end

  def play(midi, channel)
    if value = @melody[@i % @melody.size]
      @degree += value
    else
      @degree = 0
    end

    midi.note_off(@note.value, channel) if @note

    @note = @mode.at(@degree).octave_up(@octave)
    midi.note_on(@note.value, channel, 100)
    puts "note on(#{ @note.value })"

    @i += 1
  end
end

if $0 == __FILE__
  require File.join(File.dirname(__FILE__), 'beat_tree')

  mode = March::Mode.new(March::Note.from_name("A"), March::Scale.natural_minor)

  melodizer = Melodizer.new(mode, 5, [nil, -3, +2, -3] + [+2, -3, -1, +3] + [-4, +1, +1, +2] + [-1, -1, +2, +2])
  bass = Melodizer.new(mode, 4, [nil, 0, -1, 0] + [-1, 0, -1, 0] + [-4, 0, +2, 0] + [+1, 0, +1, +2])

  midi = MIDIator::Interface.new
  midi.use(:core_midi)

  loop do
    melodizer.play(midi, 0)
    bass.play(midi, 1)
    sleep 0.4
  end
end
