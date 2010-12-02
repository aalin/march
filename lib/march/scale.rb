module March
  class Scale
    def self.major ; ionian ; end
    def self.natural_minor ; aeolian ; end

    def self.harmonic_minor
      aeolian.with_offset(0, 0, 0, 0, 0, 0, 1)
    end

    def self.phrygian_dominant
      from_half_steps(1, 3, 1, 2, 1, 2, 2)
    end

    def self.pentatonic_blues
      from_half_steps(3, 2, 1, 1, 3, 2)
    end

    IONIAN_HALF_STEPS = [2, 2, 1, 2, 2, 2, 1]

    class << self
      [
        :ionian,
        :dorian,
        :phrygian,
        :lydian,
        :mixolydian,
        :aeolian,
        :locrian
      ].each_with_index do |name, i|
        define_method(name) do
          half_steps = IONIAN_HALF_STEPS.dup
          i.times { half_steps.push(half_steps.shift) }
          from_half_steps(half_steps)
        end
      end
    end

    def self.from_half_steps(*half_steps)
      values = half_steps.flatten[0..-2].inject([0]) { |a, x|
        a + [(a.last + x) % 12]
      }.uniq
      new(values)
    end

    attr_reader :values

    def initialize(values)
      @values = values
    end

    def diff(scale)
      @values.zip(scale.values.sort).map { |a,b| b - a }
    end

    def with_offset(*offsets)
      self.class.new(values.zip(offsets.flatten).map { |value, offset| value + offset })
    end

    def at(degree)
      @values[degree % @values.size] + (degree.to_i / @values.size) * 12
    end

    def closest_note_value(value)
      note_number = value % 12
      octave = value.to_i / 12

      # get the closest value
      closest_note_diff = @values.sort_by { |v| (v - note_number).abs }.first
      octave * 12 + closest_note_diff.round
    end
  end
end
