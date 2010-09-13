require File.join(File.dirname(__FILE__), '../spec_helper')

describe March::Scale do
  it 'should diff scales' do
    March::Scale.major.diff(March::Scale.major).should == [0, 0, 0, 0, 0, 0, 0]
  end

  it 'should make (0-indexed) values from half steps' do
    scale = March::Scale.from_half_steps([2, 2, 1, 2, 2, 2, 1])
    scale.values.should == [0, 2, 4, 5, 7, 9, 11]
  end
end
