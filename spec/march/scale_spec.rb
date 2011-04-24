require File.join(File.dirname(__FILE__), '../spec_helper')

describe March::Scale do
  it 'should diff scales' do
    March::Scale.major.diff(March::Scale.major).should == [0, 0, 0, 0, 0, 0, 0]
  end

  it 'should make (0-indexed) values from half steps' do
    scale = March::Scale.from_half_steps([2, 2, 1, 2, 2, 2, 1])
    scale.values.should == [0, 2, 4, 5, 7, 9, 11]
  end

  it 'should apply offsets' do
    offseted_major_scale = March::Scale.major.with_offset([0, 0, 1, 0, 0, 1, 1])
    March::Scale.major.diff(offseted_major_scale).should == [0, 0, 1, 0, 0, 1, 1]
  end

  it 'should have the pentatonic blues scale' do
    March::Scale.pentatonic_blues.values.should == [0, 3, 5, 6, 7, 10]
  end
end
