require 'test_helper'


describe "Worksheet" do

  TEXT = "newval"

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @table = @spread["Tabelle1"]
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


  it "should read&write new cell" do
    skip
    @table[1,5] = TEXT
    assert_equal(TEXT, @table[1,5])
   end


  it "should get count of rows" do
    skip("not implemented")
    count = @table.get_row_count
    assert_equal(10, count)
   end


  it "should insert row" do
    newrow = @table.insert 2
    assert_kind_of(Rubiod::Row, newrow)
    # FIXME: test count
   end

  it "should delete row" do
    assert_equal("Some", @table[1,0])
    @table.delete 1
    assert_equal("Text", @table[1,0])
    # FIXME: test count
   end

  it "should delete a repeated row " do
    skip
    count = @table.get_row_count
    @table.delete 9
    assert_equal(count-1, @table.get_row_count)
   end

end