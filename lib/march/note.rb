module March
  class Note
    include Comparable

    SHARP_NOTE_NAMES = %w(C C# D D# E F F# G G# A A# B)
    FLAT_NOTE_NAMES = %w(C Db D Eb E F Gb G Ab A Bb B)

    def self.from_name(note_name)
      value = SHARP_NOTE_NAMES.index(note_name) || FLAT_NOTE_NAMES.index(note_name)
      raise "#{ note_name } is not a note name" unless value
      new(value)
    end

    def initialize(value)
      @value = value
    end

    def name
      SHARP_NOTE_NAMES[self.value % SHARP_NOTE_NAMES.size]
    end

    def octave
      self.value / 12 - 1
    end

    def octave_up
      self.class.new(self.value + 12)
    end

    def octave_down
      self.class.new(self.value - 12)
    end

    def value
      @value.to_i
    end

    def to_i
      self.value
    end

    def to_s
      format("%-2s%d", name, octave)
    end

    def inspect
      "<#{ self.class.name } #{ to_s } (value: #{ value })>"
    end

    def <=>(other)
      self.value <=> other.value
    end
  end
end
