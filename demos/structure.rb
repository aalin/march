#!/usr/bin/env ruby

require 'beat_tree'

require 'rubygems'
require 'midiator'
require 'march'

class Drummer
  DRUM_NUMBERS = {
    :kick => 36,
    :sd_sidestick => 37,
    :snare_lh => 38,
    :hand_clap => 39,
    :snare_rh => 40,
    :low_tom_lh => 41,
    :hh_tip => 42,
    :low_tom_rh => 43,
    :hh_edge => 44,
    :mid_tom_lh => 45,
    :open_hh2 => 46,
    :mid_tom_rh => 47,
    :hi_tom_lh => 48,
    :crash1 => 49,
    :hi_tom_rh => 50,
    :ride => 51,
    :china => 52, # CY4 only
    :ride_bell => 53,
    :tamb_lh => 54,
    :spock => 55, # CY4
    :tamb_rh => 55,
    :crash2 => 57,
    :ride_punch => 59,
    :sd_rim => 61,
    :finger_snap => 63,
    :sd_ruff => 64,
    :sd_roll => 65,
    # Hihat
    :open1 => 69,
    :open2 => 70,
    :open3 => 71,
    :pedal => 72,
    :open_ped => 73,
    :op1poly => 74,
    :op2poly => 75,
    :op3poly => 76,
    :op_ped_poly => 77,
    # Crash mutes (BD5 only)
    :crash2_mute => 78,
    :crash2_mute => 79
  }

  def initialize(channel, beat_trees)
    @beat_trees = beat_trees
    @channel = channel
  end

  def play(midi, f, precision)
    @beat_trees.each do |name, beat_tree|
      beat_tree.beats_at(f, precision).each do |time, beat|
        if beat.value > 0.0
          midi.driver.note_on(DRUM_NUMBERS[name], @channel, 90 + rand(20))
        end
      end
    end
  end
end

class Bass
  def initialize(channel, beat_tree)
    @channel = channel
    @beat_tree = beat_tree
  end

  def play(midi, f, precision, chord)
    @beat_tree.beats_at(f, precision).each do |time, beat|
      midi.driver.note_off(@last_note, @channel) if @last_note

      if beat.value > 0.0
        @last_note = chord.first.octave_down.value
        midi.driver.note_on(@last_note, @channel, 90 + rand(20))
      end
    end
  end
end

class Keys
  attr_accessor :beat_trees

  def initialize(channel)
    @channel = channel
  end

  def play(midi, f, precision, chord)
    @beat_trees.each_with_index do |beat_tree, i|
      beat_tree.beats_at(f, precision).each do |time, beat|
        if beat.value > 0.0
          @last_note = chord[i % chord.size].octave_up.value
          midi.driver.note_on(@last_note, @channel, 90 + rand(20))
        end
      end
    end
  end
end

class Structure
  def initialize
    @chord_beat_tree = BeatTree.new([[1.0, 0.0, 0.0, 0.0], [1.0, 1.0, 0.0, 0.0], [1.0, 0.0, 1.0, 0.0], [1.0, 0.0, 0.0, 1.0]])
    @bass = Bass.new(1, @chord_beat_tree)

    @keys = Keys.new(0)

    @drummer = Drummer.new(2,
      :kick => BeatTree.new([[1.0, 0.0, 0.0, 0.0], [1.0, 1.0, 0.0, 0.0]] * 2),
      :snare_lh => BeatTree.new([[0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0]] * 2),
      :hh_tip => BeatTree.new([1.0, 1.0, 0.0, 1.0] * 4),
      :open1 => BeatTree.new([0.0, 0.0, 1.0, 0.0] * 4)
    )

    @mode = March::Mode.new(March::Note.from_name("D"), March::Scale.dorian)
  end

  def play!
    midi = MIDIator::Interface.new
    midi.use(:core_midi)

    tick_length = 0.08
    bar = 0

    precision = 64

    loop do
      @keys.beat_trees = random_key_beat_trees if bar % 2 == 0

      precision.times do |i| 
        start = Time.now

        t = bar + i / precision.to_f
        play(midi, t, precision.to_f)

        length = start - Time.now
        sleep(tick_length - length) if tick_length > length
      end 
    end
  end

  private

  def random_key_beat_trees
    [
      [
        BeatTree.new([[1.0, 0.0, 0.0, 0.0]] * 8),
        BeatTree.new([[0.0, 1.0, 0.0, 0.0]] * 8),
        BeatTree.new([[0.0, 0.0, 0.0, 1.0]] * 8)
      ],
      [
        BeatTree.new([[1.0, 0.0, 0.0, 0.0]] * 4),
        BeatTree.new([[0.0, 1.0, 0.0, 0.0]] * 4),
        BeatTree.new([[0.0, 0.0, 0.0, 1.0]] * 4)
      ],
      [
        BeatTree.new([[1.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 0.0]] * 4),
        BeatTree.new([[1.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0]] * 4),
        BeatTree.new([[1.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]] * 4)
      ]
    ].choice
  end

  def play(midi, t, precision)
    @drummer.play(midi, t, precision)

    @chord_beat_tree.beats_at(t, precision).each do |time, beat|
      @chord = chord_at(t) if beat.value > 0.0
    end

    if @chord
      @bass.play(midi, t, precision, @chord)
      @keys.play(midi, t, precision, @chord)
    end
  end

  def chord_at(t)
    octave = 4
    chord_root = @mode.at((Math::sin(t * Math::PI / 4) * 8).round)
    @mode.triad_for_note(chord_root(octave))
  end
end

Structure.new.play!
