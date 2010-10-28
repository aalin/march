module Mfiuegw
  class LeadPlayer
    attr_accessor :beat_tree

    def initialize(channel, octave)
      @channel = channel
      @octave = octave
    end

    def play(context)
      if context.f < Float::EPSILON
        @degree = 0
      end

      beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        next unless beat.value

        context.note_off(@last_note, @channel) if @last_note

        @degree += beat.value

        @last_note = context.mode.at(@degree).octave_up(@octave).to_i
        context.note_on(@last_note, @channel, 90 + rand(20))
      end
    end
  end
end
