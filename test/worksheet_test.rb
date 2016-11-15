require 'test_helper'


describe "Worksheet" do

  TEXT = "newval"

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @table = @spread["Tabelle1"]
    @row_count = @table.get_row_count
  end


  it "should be loaded" do
    refute_nil (@table)
   end


  it "should get a row" do
    row = @table[1]
    assert_kind_of(Rubiod::Row, row)
   end


  it "should read&write cell" do
    @table[1,0] = TEXT
    assert_equal(TEXT, @table[1,0])
   end


  it "should read&write new cell by splitting" do
    @table[1,3] = TEXT
    assert_equal(TEXT, @table[1,3])
   end

  it "should split a repeated row if a line is altered" do
    assert @table.getRowConst(3).repeated?

    @table[3,1]=NEW_TEXT
    assert_equal(NEW_TEXT, @table[3,1])

    refute @table.getRowConst(3).repeated?
   end

  it "should read&write new cell by adding cell" do
    @table[1,5] = TEXT
    assert_equal(TEXT, @table[1,5])
   end


  it "should read&write new cell by creating new row" do
    assert(@table.getRowConst(4).repeated?)
    @table[4,0] = TEXT
    assert_equal(TEXT, @table[4,0])
   end

  it "should read&write new cell by creating new row through row" do
    row = @table[16]
    row[0] = TEXT
    assert_equal(TEXT, @table[16,0])
   end

  it "should get count of rows" do
    count = @table.get_row_count
    assert_equal(15, count)
   end


  it "should insert row" do
    newrow = @table.insert 2

    assert_kind_of(Rubiod::Row, newrow)
    assert_equal(@row_count+1 , @table.get_row_count)

    @table.insert 5,5
    assert_equal(@row_count+1+5 , @table.get_row_count)
   end

  it "should insert multiple rows" do
    newrow = @table.insert 2,5

    assert_kind_of(Rubiod::Row, newrow)
    assert(newrow.repeated?)
    assert_equal(@row_count+5 , @table.get_row_count)
   end


  it "should delete row" do
    assert_equal('1', @table[1,0])

    @table.delete 1

    assert_equal("Text", @table[1,0])
    assert_equal(@row_count-1 , @table.get_row_count)
   end


  it "should delete a repeated row" do
    @table.delete 4
    assert_equal(@row_count-1, @table.get_row_count)
   end

  it "should hide a range of rows" do
    @table.modifiyRange(1..7) {|x| x.hide }

    refute(@table[0].hidden?)
    (1..7).each { |x| 
        assert(@table[x].hidden?, "line #{x} should be hidden")
    }
    refute(@table[8].hidden?)
   end

  it "should hide a range of rows incl. splitting" do
    @table.modifiyRange(5..12) {|x| x.hide }

    (5..12).each { |x| 
        assert(@table[x].hidden?, "line #{x} should be hidden")
    }
   end

  it "should hide a range of rows even when out-of-bounds" do
    @table.modifiyRange(5..99) {|x| x.hide }
   end

  it "should re-collapse rows" do
    # force split
    (0...@table.get_row_count).each {|r| @table[r,0]=@table[r,0] }
    (0...@table.get_row_count).each {|r| refute(@table[r].repeated?, "force split not working?") }

    @table.optimize

    count_rep = 0
    (0...@table.get_row_count).each {|r| count_rep+=1 if @table.getRowConst(r).repeated? }
    assert(count_rep>0, "atleast 1 row should be collapsed")
   end

end