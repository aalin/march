module Mfiuegw
  class Tune
    attr_accessor :players
    attr_accessor :chords
    attr_accessor :chord_beat_tree
    attr_accessor :modes
    attr_accessor :mode_beat_tree

    def initialize
      @players = []
      @current_chord = []
      @current_mode = []
    end

    def play(context)
      set_current_mode(context)
      set_current_chord(context)

      context.mode = @current_mode
      context.chord = @current_mode.triad(@current_chord)

      @players.each do |player|
        player.play context
      end
    end

    private

    def set_current_chord(context)
      return unless chord_beat_tree
      chord_beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        if beat.value
          @current_chord = beat.value
        end
      end
    end

    def set_current_mode(context)
      return unless mode_beat_tree
      mode_beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        if beat.value
          @current_mode = modes[beat.value]
        end
      end
    end
  end
end

