module Mfiuegw
  class BassPlayer
    attr_accessor :beat_tree

    def initialize(channel)
      @channel = channel
    end

    def play(context)
      beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        context.note_off(@last_note, @channel) if @last_note

        if beat.value > 0.0
          @last_note = context.chord.first.value
          context.note_on(@last_note, @channel, 90 + rand(20))
        end
      end
    end
  end
end
