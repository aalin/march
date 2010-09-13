module Mfiuegw
  class Tune
    attr_accessor :players
    attr_accessor :chords
    attr_accessor :chord_beat_tree
    attr_accessor :scales
    attr_accessor :scale_beat_tree

    def initialize
      @players = []
      @current_chord = []
      @current_scale = []
    end

    def play(context)
      set_current_chord(context)
      set_current_scale(context)

      context.chord = @current_chord
      context.scale = @current_scale

      @players.each do |player|
        player.play context
      end
    end

    private

    def set_current_chord(context)
      return unless chord_beat_tree
      chord_beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        if beat.value
          @current_chord = chords[beat.value]
        end
      end
    end

    def set_current_scale(context)
      return unless scale_beat_tree
      scale_beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        if beat.value
          @current_scale = scales[beat.value]
        end
      end
    end
  end
end

