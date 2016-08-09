require 'test_helper'

describe "GappedNumHash" do

  ITEM1="one"
  ITEM2="two"
  ITEM3="three"
  ITEM4="four"

  before do
    @gh = RangeHash.new
    @gh.insert 1..1, ITEM1
    @gh.insert 2..5, ITEM2
    @gh.insert 6..8, ITEM3
    @gh.insert 9..9, ITEM4
  end

  it "list should be filled" do
    assert_equal(ITEM1, @gh[1])
    assert_equal(ITEM2, @gh[2])
    assert_equal(ITEM3, @gh[8])
  end

 
end
