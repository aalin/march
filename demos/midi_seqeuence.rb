#!/usr/bin/env ruby

require 'rubygems'
require 'march'
require 'midilib/sequence'

require 'mfiuegw/bass_player'
require 'mfiuegw/chord_player'
require 'mfiuegw/drummer'
require 'mfiuegw/player'
require 'mfiuegw/tune'

include Mfiuegw

require 'beat_tree'

class MIDI::Sequence
  def track_by_name(name)
    tracks.find do |track|
      track.name == name
    end
  end
end

module Mfiuegw
  class MultiSequencePlayer
    def initialize(midi_file, track_name, channel, start_measure, end_measure)
      @sequence_players = (start_measure..end_measure).map do |measure|
        SequencePlayer.new(channel).tap do |sequence_player|
          sequence_player.sequence = Mfiuegw::Sequence.new(midi_file, track_name, measure)
        end
      end
    end

    def play(context)
      puts context.bar % @sequence_players.size
      @sequence = @sequence_players[context.bar % @sequence_players.size].play(context)
    end
  end

  class SequencePlayer
    attr_accessor :sequence

    def initialize(channel)
      @channel = channel
      @note_offs = []
    end

    def play(context)
      @note_offs.map! { |time, beat|
        if time > context.f
          [time, beat]
        else
          context.note_off(beat.value[:note], @channel, 100)
          nil
        end
      }.compact!

      sequence.beats_at(context.f % 1.0, context.precision).each do |time, beats|
        beats.each do |beat|
          context.note_on(beat.value[:note], @channel, beat.value[:velocity])
          @note_offs << [
            context.f + beat.length,
            beat
          ]
        end
      end
    end
  end

  class Sequence
    def initialize(midi_file, track_name, measure_index)
      seq = MIDI::Sequence.new()
      File.open(midi_file, 'rb') do |file|
        seq.read(file)
      end

      @measure = seq.get_measures[measure_index] or raise "No measure #{ measure_index } found"
      @track   = seq.track_by_name(track_name)   or raise "No track with name #{ track_name } found"

      @events = {}
      open_events = {} # event.note => event

      @track.events.each do |event|
        next unless @measure.contains_event?(event)

        if event.note_on?
          open_events[event.note] = event
        elsif event.note_off?
          if open_event = open_events[event.note]
            f = ((open_event.time_from_start - @measure.start) / (@measure.end - @measure.start).to_f)
            length = (event.time_from_start - open_event.time_from_start) / (@measure.end - @measure.start)
            open_events.delete(event.note)
            @events[f] ||= []
            @events[f] << BeatTree::Beat.new({ :note => event.note, :velocity => open_event.velocity }, length)
          else
            puts "No open event found here."
          end
        else
          puts "Unrechognized event: #{ event.inspect }"
        end
      end
    end

    def beats_at(t, precision)
      @events.select do |time, v| 
        time >= t && time < t + 1.0 / precision
      end
    end
  end
end

piano_player = MultiSequencePlayer.new(File.join(File.dirname(__FILE__), 'mfiuegw.mid'), 'Piano',    0, 0, 1)
bass_player = MultiSequencePlayer.new(File.join(File.dirname(__FILE__), 'mfiuegw.mid'),  'Bass',     1, 0, 1)
lead_player = MultiSequencePlayer.new(File.join(File.dirname(__FILE__), 'mfiuegw.mid'),  'Melodies', 3, 0, 1)

drummer = Drummer.new(2)
drummer.beat_trees = {
  :kick => BeatTree.new([[1.0, 0.0, 0.0, 0.0], [1.0, 1.0, 0.0, 0.0]] * 2),
  :snare_lh => BeatTree.new([[0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, [1.0, 1.0]]]),
  :hh_tip => BeatTree.new([1.0, 1.0, 0.0, 1.0] * 4),
  :open1 => BeatTree.new([0.0, 0.0, 1.0, 0.0] * 4),
  :crash1 => BeatTree.new([[1.0, 0.0, 0.0, 0.0], 0.0, 0.0, 0.0]),
  :crash2 => BeatTree.new([[0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 0.0, 0.0])
}

tune = Tune.new
tune.players << piano_player
tune.players << bass_player
tune.players << lead_player
tune.players << drummer

Player.new(tune).play!
