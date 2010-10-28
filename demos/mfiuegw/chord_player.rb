module Mfiuegw
  class ChordPlayer
    attr_accessor :beat_tree

    def initialize(channel, stop_on_nil = true)
      @channel = channel
      @stop_on_nil = stop_on_nil
      @last_notes = []
      @degree = 0
    end

    def play(context)
      if context.f < Float::EPSILON
        @degree = 0
      end

      beat_tree.beats_at(context.f, context.precision).each do |time, beat|
        puts @degree.inspect
        @degree += beat.value if beat.value
        chord = context.mode.triad(@degree)

        if @stop_on_nil ? beat.value : @last_notes != chord
          @last_notes.each do |note|
            context.note_off(note.octave_up(4).value, @channel)
          end

          chord.each do |note|
            context.note_on(note.octave_up(4).value, @channel, 90 + rand(20))
          end

          @last_notes = chord
        end
      end
    end
  end
end
