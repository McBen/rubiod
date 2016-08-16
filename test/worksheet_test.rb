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
    assert @table[3].repeated?

    @table[3,1]=NEW_TEXT
    assert_equal(NEW_TEXT, @table[3,1])

    refute @table[3].repeated?
   end

  it "should read&write new cell by adding cell" do
    skip
    @table[1,5] = TEXT
    assert_equal(TEXT, @table[1,5])
   end


  it "should read&write new cell by creating new row" do
    assert(@table[4].repeated?)
    @table[4,0] = TEXT
    assert_equal(TEXT, @table[4,0])
   end

  it "should get count of rows" do
    count = @table.get_row_count
    assert_equal(9, count)
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
    assert_equal("Some", @table[1,0])

    @table.delete 1

    assert_equal("Text", @table[1,0])
    assert_equal(@row_count-1 , @table.get_row_count)
   end


  it "should delete a repeated row " do
    @table.delete 4
    assert_equal(@row_count-1, @table.get_row_count)
   end

end