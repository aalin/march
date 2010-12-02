module EventFilters
  class BasicEventFilter
    def filter(events)
      events.map { |event|
        filter_event(event)
      }.compact
    end

    private

    def filter_event(event)
      event
    end

    def note_value(event)
      event[1]
    end

    def note_velocity(event)
      event[2]
    end

    def update_event(event, index, value)
      event.dup.fill(value, index, 1)
    end
  end

  class WhiteKeyFilter < BasicEventFilter
    def initialize(mode)
      @mode = mode
      @major_scale_values = March::Scale.major.values
    end

    private

    def filter_event(event)
      octave, note_value = note_value(event).divmod(12)

      if note_index = @major_scale_values.index(note_value)
        note = @mode.at(note_index).octave_up(octave)
        update_event(event, 1, note.value)
      else
        puts "Note not in C major: #{ March::Note.new(note_value(event)) }"
      end
    end
  end

  class ClosestNoteFilter < BasicEventFilter
    def initialize(mode)
      @mode = mode
    end

    private

    def filter_event(event)
      given_note = March::Note.new(note_value(event))
      note = @mode.closest_note(given_note.value)

      velocity = note_velocity(event)

      if note.value != given_note.value
        puts "\e[33m#{ given_note } -> #{ note }\e[0m"
      end

      update_event(event, 1, note.value)
    end
  end

  class OnlyInModeFilter < BasicEventFilter
    def initialize(mode)
      @mode = mode
    end

    private

    def filter_event(event)
      note = March::Note.new(note_value(event))
      velocity = note_velocity(event)

      if @mode.include?(note)
        update_event(event, 1, note.value)
      else
        puts "\e[33m%s\e[0m" % note.to_s
      end
    end
  end

  class ChordmakerFilter < BasicEventFilter
    def initialize(mode)
      @mode = mode
    end

    def filter(events)
      events.inject([]) do |events, event|
        events + filter_event(event)
      end
    end

    private

    def filter_event(event)
      chord_root = March::Note.new(note_value(event))
      velocity = note_velocity(event)

      notes = @mode.triad_for_note(chord_root)
      notes.map { |note| update_event(event, 1, note.value) }
    end
  end
end
