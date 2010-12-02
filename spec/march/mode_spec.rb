require File.join(File.dirname(__FILE__), '../spec_helper')

describe March::Mode do
  it 'should make a new mode from a root note and a scale' do
    mode = March::Mode.new(March::Note.from_name("A"), March::Scale.major)
    mode.root.value.should == 9
  end

  context 'with a mode' do
    before do
      @mode = March::Mode.new(March::Note.from_name("C"), March::Scale.major)
    end

    it 'should get the first note' do
      @mode.at(0).should == March::Note.from_name("C")
    end

    it 'should get the second note' do
      @mode.at(1).should == March::Note.from_name("D")
    end

    it 'should tell whether a note is in the mode or not' do
      @mode.include?(March::Note.from_name('C')).should == true
      @mode.include?(March::Note.from_name('Db')).should == false
      @mode.include?(March::Note.from_name('G')).should == true
      @mode.include?(March::Note.from_name('Ab')).should == false
    end

    it 'should give a higher value if I send a higher degree' do
      @mode.at(7 + 0).value.should == March::Note.from_name("C").value + 12
      @mode.at(7 + 1).value.should == March::Note.from_name("D").value + 12
      @mode.at(7 + 7 + 2).value.should == March::Note.from_name("E").value + 12 + 12
    end

    it 'should get the closest note' do
      @mode.closest_note(60).value.should == 60
      @mode.closest_note(61).value.should == 60
      @mode.closest_note(61.5).value.should == 62
      @mode.closest_note(62).value.should == 62
      @mode.closest_note(62.5).value.should == 62
      @mode.closest_note(63).value.should == 64
      @mode.closest_note(64).value.should == 64
    end

    it 'should get the closest note' do
      @mode.closest_note(60).name.should == 'C'
      @mode.closest_note(64).name.should == 'E'
    end
  end

  context 'doing triads' do
    # Major triads contain a major third and perfect fifth interval, symbolized: R 3 5 (or 0-4-7 as semitones) About this sound play (help·info)
    # minor triads contain a minor third, and perfect fifth, symbolized: R ♭3 5 (or 0-3-7) About this sound play (help·info)
    # diminished triads contain a minor third, and diminished fifth, symbolized: R ♭3 ♭5 (or 0-3-6) About this sound play (help·info)
    # augmented triads contain a major third, and augmented fifth, symbolized: R 3 ♯5 (or 0-4-8) About this sound play (help·info)

    context 'with C major' do
      before do
        @mode = March::Mode.new(March::Note.from_name("C"), March::Scale.major)
      end

      [
        %w(C  E  G ), # C major
        %w(D  F  A ), # D minor
        %w(E  G  B ), # E minor
        %w(F  A  C ), # F major
        %w(G  B  D ), # G major
        %w(A  C  E ), # A minor
        %w(B  D  F ), # B diminished
        %w(C  E  G ) # C major
      ].each_with_index do |note_names, degree|
        it "should give #{ note_names.join(", ") } at degree #{ degree }" do
          @mode.triad(degree).map(&:name).should == note_names
        end
      end
    end

    context 'with D dorian' do
      before do
        @mode = March::Mode.new(March::Note.from_name("D"), March::Scale.dorian)
        @mode.notes.map(&:name).should == %w(D E F G A B C)
      end

      [
        %w(D  F  A ), # D minor
        %w(E  G  B ), # E minor
        %w(F  A  C ), # F major
        %w(G  B  D ), # G major
        %w(A  C  E ), # A minor
        %w(B  D  F ), # B diminished
        %w(C  E  G ), # C major
        %w(D  F  A ), # D minor
      ].each_with_index do |note_names, degree|
        it "should give #{ note_names.join(", ") } at degree #{ degree }" do
          @mode.triad(degree).map(&:name).should == note_names
        end
      end
    end

    context 'with C phrygian dominant' do
      before do
        @mode = March::Mode.new(March::Note.from_name("C"), March::Scale.phrygian_dominant)
      end

      it 'should give G#aug for the fifth degree' do
        @mode.triad(5).map(&:name).should == %w(G# C E)
      end
    end
  end
end
