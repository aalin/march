module Mfiuegw
  class ChordPlayer
    attr_accessor :beat_tree

    def initialize(channel, stop_on_nil = true)
      @channel = channel
      @stop_on_nil = stop_on_nil
      @last_notes = []
    end

    def play(context)
      chord = context.chord

      beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        if @stop_on_nil ? beat.value : @last_notes != chord
          @last_notes.each do |note|
            context.note_off(note.value, @channel)
          end

          chord.each do |note|
            context.note_on(note.value, @channel, 90 + rand(20))
          end

          @last_notes = chord
        end
      end
    end
  end
end
