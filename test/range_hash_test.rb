require 'test_helper'

describe "RangeHash" do

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

  it "should get max count" do
    assert_equal(9, @gh.last_index)

    @gh.insert 10..11, ITEM4
    assert_equal(11, @gh.last_index)
  end

  it "should get key and val" do
    key,val = @gh.at(1)
    assert_equal(1..1, key)

    key,val = @gh.at(3)
    assert_equal(2..5, key)
   end

  it "should reduce all ranges" do
    res = @gh.taper(3,2)

    assert_equal([2..3,ITEM2],res)
    assert_equal(7, @gh.last_index)
    assert_equal([4..6,ITEM3], @gh.at(4))
   end

  it "should delete a key" do
    res = @gh.delete(1)
    assert_equal([1..1,ITEM1],res)
    assert_equal(8, @gh.last_index)
   end

  it "should delete a key-range" do
    res = @gh.delete(2)
    assert_equal([2..5,ITEM2],res)
    assert_equal(5, @gh.last_index)
   end

end
