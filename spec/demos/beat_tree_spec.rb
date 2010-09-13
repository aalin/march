require File.join(File.dirname(__FILE__), '../spec_helper')

require 'demos/beat_tree'

describe BeatTree::Beat do
  before do
    @beat = BeatTree::Beat.new(123, 0.25)
  end

  it 'should have a value' do
    @beat.value.should == 123
  end

  it 'should have a length' do
    @beat.length.should == 0.25
  end

  it 'should make a nice string' do
    @beat.to_s.should == "Beat(value: 123, length: 0.2500)"
  end
end

describe BeatTree do
  before do
    @tree = [
      [1, 0, 0, 1], # four eighths
      [1, 0, 0, # three eighths
        [ # one eighth
          0, # one sixteenth
          [1, 1, 1] # triplet
        ]
      ]
    ]
    @beat_tree = BeatTree.new(@tree)
  end

  context 'to_counter_matches' do
    it 'should make counter matches'
  end

  context 'pattern' do
    it 'should give a pattern' do
      beat_values = @beat_tree.pattern.map { |time, beat| beat.value }
      beat_values.should == @tree.flatten
    end

    it 'should cache the pattern' do
      @beat_tree.pattern.object_id.should == @beat_tree.pattern.object_id
    end
  end

  context 'beats_at' do
    it 'should give the beats at a time' do
      {
        0 / 8.0 => [1],
        1 / 8.0 => [0],
        2 / 8.0 => [0],
        3 / 8.0 => [1],
        4 / 8.0 => [1],
        5 / 8.0 => [0],
        6 / 8.0 => [0],
        7 / 8.0 => [0],
        8 / 8.0 => [1, 1, 1]
      }.each do |time, values|
        @beat_tree.beats_at(time, 8).map(&:last).map(&:value).should == values
      end
    end
  end
end

