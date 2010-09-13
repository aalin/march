#!/usr/bin/env ruby -rubygems -rlib/march -Idemos

require File.join(File.dirname(__FILE__), 'beat_tree')

require 'mfiuegw/bass_player'
require 'mfiuegw/chord_player'
require 'mfiuegw/drummer'
require 'mfiuegw/player'
require 'mfiuegw/tune'


if __FILE__ == $0
  include Mfiuegw

  chord_player = ChordPlayer.new(0)

  chord_player.beat_tree = BeatTree.new [
    # part 1
    [0, nil, nil, 1],
    [nil, 2, nil, 3],
    [nil, nil, 4, 5],
    [6, nil, 7, nil],
    # part 2
    [8, nil, 8, nil],
    [8, nil, 8, 9],
    [10, nil, 10, nil],
    [10, nil, 9, nil],
  ]

  bass_player = BassPlayer.new(1)
  bass_player.beat_tree = BeatTree.new [
    [
      [100, 0, 100, 0],
    ] * 8
  ]

  drummer = Drummer.new(2)
  drummer.beat_trees = {
    :kick => BeatTree.new([[1.0, 0.0, 0.0, 0.0], [1.0, 1.0, 0.0, 0.0]] * 2),
    :snare_lh => BeatTree.new([[0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, [1.0, 1.0]]]),
    :hh_tip => BeatTree.new([1.0, 1.0, 0.0, 1.0] * 4),
    :open1 => BeatTree.new([0.0, 0.0, 1.0, 0.0] * 4),
    :crash1 => BeatTree.new([[1.0, 0.0, 0.0, 0.0], 0.0, 0.0, 0.0]),
    :crash2 => BeatTree.new([[0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 0.0, 0.0])
  }

  organ_player = ChordPlayer.new(3, false)

  organ_player.beat_tree = BeatTree.new [
    # part 1
    [0, nil, nil, 1],
    [nil, 2, nil, 3],
    [nil, nil, 4, 5],
    [6, nil, 7, nil],
    # part 2
    [8, nil, 8, nil],
    [8, nil, 8, 9],
    [10, nil, 10, nil],
    [10, nil, 9, nil],
  ]

  tune = Tune.new

  tune.players << chord_player
  tune.players << organ_player
  tune.players << bass_player
  tune.players << drummer

  tune.chords = [
    # part 1
    [49, 56, 61, 64, 68, 73],
    [44, 51, 56, 59, 63, 68],
    [52, 55, 58, 62, 67],
    [42, 54, 57, 61, 66],
    [52, 59, 64],
    [44, 49, 56, 61],
    [47, 52, 56, 59, 64],
    [42, 54, 57, 61, 66, 73],
    # part 2
    [59, 57, 62],
    [58, 56, 61],
    [42, 49, 54],
    [45, 52, 57],
  ].map { |chord| chord.map { |i| March::Note.new(i) } }

  tune.chord_beat_tree = BeatTree.new [
    # part 1
    [0, nil, nil, 1],
    [nil, 2, nil, 3],
    [nil, nil, 4, 5],
    [6, nil, 7, nil],
    # part 2
    [8, nil, 8, nil],
    [8, nil, 8, 9],
    [10, nil, 10, nil],
    [10, nil, 9, nil],
  ]

  puts tune.chord_beat_tree.pattern

  tune.scales = [
    March::Scale.new(tune.chords[0, 3].flatten.map { |note| note.value % 12 }.uniq.sort),
    March::Scale.new(tune.chords[4, 7].flatten.map { |note| note.value % 12 }.uniq.sort),
  ]

  tune.scale_beat_tree = BeatTree.new [
    [0, 1]
  ]

  Player.new(tune).play!
end
