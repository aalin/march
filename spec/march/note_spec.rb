require File.join(File.dirname(__FILE__), '../spec_helper')

describe March::Note do
  context "from note names" do
    it 'should create notes from note names' do
      March::Note.from_name("C").value.should == 0
      March::Note.from_name("D").value.should == 2
      March::Note.from_name("F").value.should == 5
    end

    it 'should create notes from sharp note names' do
      March::Note.from_name("C#").value.should == 1
      March::Note.from_name("D#").value.should == 3
      March::Note.from_name("F#").value.should == 6
    end

    it 'should create notes from flat note names' do
      March::Note.from_name("Db").value.should == 1
      March::Note.from_name("Eb").value.should == 3
      March::Note.from_name("Gb").value.should == 6
    end

    it 'should raise an exception if a note name is not found' do
      lambda {
        March::Note.from_name("ASD")
      }.should raise_error
    end
  end

  it 'should have a note name' do
    March::Note.new(60).name.should == "C"
    March::Note.new(61).name.should == "C#"
  end

  it 'should give the right octave' do
    March::Note.new(60).octave.should == 4
    March::Note.new(61).octave.should == 4
    March::Note.new(60 + 12).octave.should == 5
    March::Note.new(61 - 12).octave.should == 3
  end

  it 'should make strings with name and octave' do
    March::Note.new(60).to_s.should == "C 4"
    March::Note.new(61).to_s.should == "C#4"
  end

  it 'should compare notes' do
    March::Note.new(60).should == March::Note.new(60)
    March::Note.new(60).should < March::Note.new(61)
    March::Note.new(60).should > March::Note.new(59)
  end
end
