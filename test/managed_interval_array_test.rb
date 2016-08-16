require 'test_helper'

class TestManagedObject

  attr_accessor :value
  attr_reader :status

  def initialize value
    @value = value
    @status = ''
  end

  def duplicate
    # NB: must copy count!
    #     new item must be created BEHIND old
    @status += 'Dup'
    TestManagedObject.new(@value)
  end

  def delete!
    @status += 'Del'
  end

  def setCount num
    @status += "C#{num}"
  end

end


describe "ManagedIntervalArray" do

  before do
    @marray = ManagedIntervalArray.new
    @marray.add TestManagedObject.new(0), 1 # [0]
    @marray.add TestManagedObject.new(1), 5 # [1-5]
    @marray.add TestManagedObject.new(2), 1 # [6]
    @marray.add TestManagedObject.new(3), 3 # [7-9]
    @size = @marray.size
   end

  it "should give correct count" do
    ar = ManagedIntervalArray.new
    assert_equal(0,ar.size)

    ar.add TestManagedObject.new(0)
    assert_equal(1,ar.size)

    ar.add TestManagedObject.new(1),5
    assert_equal(6,ar.size)
   end

  
  it "should create array and find all indices" do

    def fullTest(ar)
      test_ar = ManagedIntervalArray.new

      ar.each_with_index { |count,value| test_ar.add TestManagedObject.new(value),count }

      index=0
      ar.each_with_index { |count,value| 
        (0...count).each { 
          assert_equal(value,test_ar[index].value, " in #{ar} at #{index} -> ")
          index +=1
        }
      }

      assert_nil(test_ar[index], "should give nil if out-of-bounds")
    end

    fullTest( [1,5,1,3] )
    fullTest( [4,1] )
    fullTest( [1] )
    fullTest( [1,2,3,4,5,6,7,8,9] )
    fullTest( [8,7,6,5,4,3,2,1] )
   end


  it "should give correct countOf value" do
    assert_equal(1,@marray.countOf(0) )
    assert_equal(5,@marray.countOf(1) )
    assert_equal(5,@marray.countOf(3) )
    assert_equal(1,@marray.countOf(6) )
   end


  it "should delete a single value" do
    @marray.delete 0
    assert_equal(1,@marray[0].value)
    assert_equal(@size-1,@marray.size)
   end


  it "should reduce a multiple value" do
    @marray.delete 1
    assert_equal(1,@marray[1].value)
    assert_equal(@size-1,@marray.size)
   end


  it "should call delete function of managed object" do
    val = @marray[6]
    @marray.delete 6
    assert_equal("Del",val.status)
   end


  it "should call reduce function of managed object" do
    val = @marray[1]
    @marray.delete 1
    assert_equal("C4",val.status)
   end

  it "should insert new item at end" do
    @marray.insert(20,4)

    assert_equal( 24,@marray.size )
   end

  it "should insert new item at beginning" do
    @marray.insert(0,4)

    assert_equal( @size+4,@marray.size )
    assert_equal( 4,@marray.countOf(2) )

    assert_equal( 1,@marray.countOf(4) )
   end

  it "should insert new item" do
    @marray.insert(6,4)

    assert_equal( @size+4,@marray.size )
    assert_equal( 4,@marray.countOf(6) )
    assert_equal( 1,@marray.countOf(10) )
   end

  it "should insert new item at beginning of a repeated" do
    @marray.insert(1,4)

    assert_equal( @size+4,@marray.size )
    assert_equal( 1, @marray.countOf(0) )
    assert_equal( 4, @marray.countOf(1) )
    assert_equal( 5, @marray.countOf(5) )
   end

  it "should insert new item in middle of a repeated should split it" do
    @marray.insert(3,4)

    assert_equal( @size+4,@marray.size )
    assert_equal( 2, @marray.countOf(1) )
    assert_equal( 4, @marray.countOf(3) )
    assert_equal( 3, @marray.countOf(8) )
   end

  it "insert at end should duplicate last item" do
    newitem = @marray.insert(20,4)

    assert_equal( 3,@marray[9].value )
    assert_equal( 3,@marray[10].value )
    assert_equal( 3,@marray[20].value )

    newitem.value = 'test'
    assert_equal( 'test',@marray[20].value )
    assert_equal( "Dup", @marray[9].status )
    assert_equal( "C10Dup", @marray[10].status )
    assert_equal( "C4", @marray[20].status )

    assert_equal( 24,@marray.size )
   end

  it "insert at beginning should duplicate first item" do
    newitem = @marray.insert(0,4)

    assert_equal( 0,@marray[0].value )
    assert_equal( 0,@marray[4].value )

    newitem.value = 'test'
    assert_equal( 'test',@marray[0].value )
    assert_equal( 0, @marray[4].value )
    assert_equal( "DupC4", @marray[0].status )
    assert_equal( "", @marray[4].status )
   end

  it "insert at should duplicate previous item" do
    newitem = @marray.insert(6,4)

    assert_equal( 1,@marray[6].value )

    newitem.value = 'test'
    assert_equal( 'test',@marray[6].value )
    assert_equal( 2, @marray[10].value )
    assert_equal( "Dup", @marray[5].status )
    assert_equal( "C4", @marray[6].status )
   end

  it "insert new item in middle of a repeated should duplicate the items" do
    newitem = @marray.insert(3,4)

    newitem.value = 'test'
    assert_equal( 'test',@marray[3].value )
    assert_equal( 1, @marray[1].value )
    assert_equal( 1, @marray[7].value )

    assert_equal( "DupC2Dup", @marray[1].status )
    assert_equal( "C4", @marray[3].status )
    assert_equal( "C3", @marray[7].status )
   end

end