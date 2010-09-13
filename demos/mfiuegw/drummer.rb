module Mfiuegw
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

    def initialize(channel)
      @channel = channel
    end

    attr_accessor :beat_trees

    def play(context)
      beat_trees.each do |name, beat_tree|
        beat_tree.beats_at(context.f, context.precision).each do |time, beat|
          if beat.value > 0.0
            context.note_on(DRUM_NUMBERS[name], @channel, 90 + rand(20))
          end
        end
      end
    end
  end
end
