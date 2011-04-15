module Mfiuegw
  class Player
    class Context
      attr_reader :bar
      attr_reader :f
      attr_reader :channel_notes
      attr_reader :precision
      attr_reader :channel_notes

      attr_accessor :chord
      attr_accessor :mode

      def initialize(midi, i, precision)
        @midi = midi
        @precision = precision

        @channel_notes = {}

        @bar, @x = i.divmod(precision)
        @f = @x / precision.to_f
      end

      def self.play(midi, i, precision, tick_length)
        start = Time.now
        
        yield new(midi, i, precision)

        puts "-" * 80

        length = Time.now - start
        # puts length
        sleep(tick_length - length) if tick_length > length
      end

      def to_s
        format("%3d %3d %.2f", @bar, @x, @f)
      end

      def value_format(value)
        format("\37m%3d\e", value)
      end

      def print_note_str(note, channel, velocity, color)
        str = "\e[37;%dm%3d\e[30m ch\e[37m%0.2x\e[30m vel\e[37m%3d\e[0m" % [color, note, channel, velocity]
        puts str.rjust(channel * 16 + str.length)
      end

      def note_on(note, channel, velocity = 100)
        print_note_str(note, channel, velocity, 42)
        @midi.note_on(note, channel, velocity)
        @channel_notes[channel] ||= []
        @channel_notes[channel] << note
      end

      def note_off(note, channel, velocity = 0)
        print_note_str(note, channel, velocity, 41)
        @midi.note_off(note, channel, velocity)
      end
    end

    def initialize(tune)
      @tune = tune
    end

    def play!
      midi = MIDIator::Interface.new
      midi.use(:core_midi)

      i = 0
      loop do
        Context.play(midi, i, 64, 0.1) do |context|
          play context
        end
        i += 1
      end
    end

    protected

    def play(context)
      @tune.play(context)
    end
  end
end
