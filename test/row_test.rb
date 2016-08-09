require 'test_helper'


describe "Row" do

  NEW_TEXT="some new text"

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @table = @spread["Tabelle1"]
    @row = @table[2]
    @row_repeated = @table[3]
  end

  it "should be loaded" do
    refute_nil (@row)
   end


  it "should recognize repeated rows" do
    assert (@row_repeated.repeated?)
    assert_equal(3, @row_repeated.repeated?)
   end

  it "should read&write cell" do
    assert_equal("Text", @row[0])
    @row[0] = NEW_TEXT
    assert_equal(NEW_TEXT, @row[0])
   end

  it "should write new cell" do
    skip() # FIXME can't insert a new cell
    @row[5] = NEW_TEXT
    assert_equal(NEW_TEXT, @row[5])
   end

  it "should get count of cells in row" do
    assert_equal(5, @row.cellnum)
    assert_equal(5, @row_repeated.cellnum)
   end


  it "should reduce repeated row" do
    @table.delete 3
    @table.delete 3
    refute (@table[3].repeated?)
   end

end