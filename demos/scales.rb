#!/usr/bin/env ruby

require 'rubygems'
require 'march'
require 'midiator'

class Drums
  def initialize(midi)
    @midi = midi
  end

  def kick!
    @midi.driver.note_on(36, 2, 100)
  end

  def snare!
    @midi.driver.note_on(38, 2, 100)
  end

  def hihat!
    @midi.driver.note_on([42, 44].choice, 2, 70 + rand(20))
  end
end

class MusicThing
  def play
    midi = MIDIator::Interface.new
    midi.use(:core_midi)

    drums = Drums.new(midi)

    4.times do |x|
      drums.hihat!
      sleep 0.5
    end

    8.times do |x|
      drums.hihat!
      sleep 0.25
    end

    i = 0
    loop do
      play_on(midi, i)
      i += 1
    end
  end

  private

  def play_on(midi, i)
    randomize_mode! if i % 16 == 0

    notes = chord_at(i)
    puts notes.join(", ")

    midi.driver.note_on(notes.first.value, 1, 80 + rand(40))

    drums = Drums.new(midi)

    shuffled_notes = notes.shuffle
    4.times do |x|
      drums.kick!  if x % 4 == 0
      drums.kick! if x % 4 == 3 && i % 2 == 0
      drums.snare! if x % 4 == 2
      drums.snare! if x % 4 == 3 && i % 4 == 3
      drums.hihat! if x % 1 == 0

      note = shuffled_notes[x] || notes.choice
      puts "  #{ note }"
      midi.driver.note_on(note.value, 0, 90 + rand(20))
      sleep 0.25
    end

    midi.driver.note_off(notes.first.value, 1)

    notes.each { |note| midi.driver.note_off(note.value, 0) }
  end

  def chord_at(i)
    octave = 4
    chord_root = @mode.at((Math::sin(i * Math::PI / 4) * 4).round)
    @mode.triad_for_note(chord_root.octave_up(octave))
  end

  def randomize_mode!
    root = March::Note.from_name(March::Note::SHARP_NOTE_NAMES.choice)
    scale = [:ionian, :dorian, :phrygian, :lydian, :mixolydian, :aeolian, :locrian].choice
    puts "Mode is #{ root.name } #{ scale }"
    @mode = March::Mode.new(root, March::Scale.send(scale))
  end
end

MusicThing.new.play
