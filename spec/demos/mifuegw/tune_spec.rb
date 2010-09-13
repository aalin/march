require File.join(File.dirname(__FILE__), '../../spec_helper')

require 'demos/mfiuegw'

describe Mfiuegw::Tune do
  before do
    @tune = Mfiuegw::Tune.new
  end

  it 'should have players' do
    player = mock(Mfiuegw::Player)
    @tune.players << player
    @tune.players.should == [player]
  end
end
