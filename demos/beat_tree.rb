class BeatTree
  class Beat
    attr_accessor :value
    attr_accessor :length

    # Value could be anything... Velocity, probability, chord...
    # An array or hash with all or any of these.
    def initialize(value, length)
      self.value = value
      self.length = length
    end

    def to_s
      "Beat(value: %s, length: %.4f)" % [ self.value.inspect, self.length ]
    end
  end

  def initialize(tree)
    @tree = tree
  end

  def pattern
    @pattern ||= generate_pattern.sort_by { |time, beat| time }
  end

  def beats_at(t, precision)
    self.pattern.select { |time, v|
      time <= t && time > t - 1.0 / precision
    }
  end

  def last_beat(t)
    time, beat = pattern.reverse.find { |time, beat| time <= t }
    beat
  end

  def to_counter_matches(skip_value = nil)
    pattern.map { |time, beat|
      next if beat.value == skip_value
      t = (time * 4 * 4 * 240).to_i
      match = Counter.new(t).to_a
      match[0] = nil
      [match, beat]
    }.compact
  end

  private

  def generate_pattern
    x = 0.0
    evaluate.inject({}) do |pattern, beat|
      val = { x => beat }
      x += beat.length
      pattern.merge(val)
    end
  end

  def evaluate(node = @tree, parent = nil, length = 1.0)
    node.inject([]) { |beats, child|
      case child
      when Array
        beats << evaluate(child, node, length / node.size)
      else
        beats + [ Beat.new(child, length / node.size) ]
      end
    }.flatten
  end
end

if $0 == __FILE__
  WIDTH = 100

  drum_trees = {}

  drum_trees["Kick"]  = BeatTree.new([[1,0,0,1], [1,0,0,[0,[1, 1, 1]]]])
  drum_trees["Snare"] = BeatTree.new([[0,0,1,0], [0,0,1,0]])
  drum_trees["Hihat"] = BeatTree.new([[1,1,1,1], [1,1,1,1]])

  drum_trees.each do |drum, beat_tree|
    print drum.ljust(10)

    0.upto(WIDTH) do |i|
      x = i / WIDTH.to_f

      if note = beat_tree.pattern.find { |time, note| time <= x && time > x - 1.0 / WIDTH }
        print note.last.value == 1 ? "X" : "-"
      else
        print "-"
      end
    end
    puts
  end
end

