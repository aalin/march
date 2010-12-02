module March
  class Mode
    attr_reader :root
    attr_reader :scale

    def initialize(root, scale)
      @root = root
      @scale = scale
    end

    def at(degree)
      March::Note.new(self.scale.at(degree) + self.root.value)
    end

    def closest_note(note_value)
      March::Note.new(self.scale.closest_note_value(note_value - self.root.value) + self.root.value)
    end

    def include?(note)
      notes.any? { |n| n.value == note.value % 12 }
    end

    def triad(degree)
      triad_for_note(at(degree))
    end

    def triad_for_note(chord_root)
      [
        chord_root,
        third(chord_root),
        fifth(chord_root)
      ].compact
    end

    def notes
      Array.new(scale.values.size) { |degree| at(degree) }
    end

    private

    def third(note)
      note_half_steps_from_note(note, [3, 4])
    end

    def fifth(note)
      note_half_steps_from_note(note, [7, 6, 8])
    end

    # Tries to get the first note that matches any of half_steps away from the note at degree.
    def note_half_steps_from_note(root, half_steps)
      half_steps.each do |half_steps_from_root|
        value = root.value + half_steps_from_root
        if notes.find { |note| note.value % 12 == value % 12 }
          return March::Note.new(value)
        end
      end
      nil
    end
  end
end
