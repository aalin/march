#!/usr/bin/env ruby

require 'march'
require 'midiator'

require 'mfiuegw/bass_player'
require 'mfiuegw/chord_player'
require 'mfiuegw/lead_player'
require 'mfiuegw/drummer'
require 'mfiuegw/player'
require 'mfiuegw/tune'
require 'beat_tree'

if __FILE__ == $0
  include Mfiuegw

  chord_player = ChordPlayer.new(0)

  chord_player.beat_tree = BeatTree.new([
    [0, nil, [0, 2]],
    [1, nil, [0, 1]],
    [1, nil, [0, -2]],
    [-1, nil, [1, 0]]
  ])

  bass_player = LeadPlayer.new(1, 3)
  bass_player.beat_tree = BeatTree.new [
    [0, nil, 0, nil],
    [3, nil, 0, nil],
    [2, nil, 0, nil],
    [-3, nil, 1, nil]
  ]

  drummer = Drummer.new(2)
  drummer.beat_trees = {
    :kick => BeatTree.new([1.0, 1.0, 1.0, 1.0] * 2),
    :sd_sidestick => BeatTree.new([1.0, 0.0, 1.0, 1.0] * 4),
    :snare_lh => BeatTree.new([[0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, [1.0, 1.0]]]),
    :hh_tip => BeatTree.new([1.0, 1.0, 0.0, 1.0] * 4),
    :open1 => BeatTree.new([0.0, 0.0, 1.0, 0.0] * 4),
    :crash1 => BeatTree.new([[1.0, 0.0, 0.0, 0.0], 0.0, 0.0, 0.0]),
    :crash2 => BeatTree.new([[0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 0.0, 0.0])
  }

  organ_player = ChordPlayer.new(3, false)
  organ_player.beat_tree = BeatTree.new [
    [0, nil, 0, nil],
    [3, nil, 0, nil],
    [2, nil, 0, nil],
    [-3, nil, 1, nil]
  ]

  lead_player = LeadPlayer.new(5, 4)
  lead_player.beat_tree = BeatTree.new [
    [0, nil, [0, 2]],
    [1, nil, [0, 1]],
    [[1, 7,], [nil], [-7, -2]],
    [-1, nil, [1, 0]],
  ]

  tune = Tune.new

#  tune.players << chord_player
  tune.players << organ_player
  tune.players << bass_player
  tune.players << drummer
  tune.players << lead_player

  tune.chord_beat_tree = BeatTree.new [
    [0, nil, 0, nil],
    [3, nil, 0, nil],
    [5, nil, 0, nil],
    [2, nil, 1, nil]
  ]

  puts tune.chord_beat_tree.pattern

  tune.modes = [
    March::Mode.new(March::Note.from_name("A"), March::Scale.dorian)
  ]

  tune.mode_beat_tree = BeatTree.new([0])

  Player.new(tune).play!
end
