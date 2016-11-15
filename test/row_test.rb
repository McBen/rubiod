require 'test_helper'


describe "Row" do

  NEW_TEXT="some new text"

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @table = @spread["Tabelle1"]
    @row = @table.getRowConst(2)
    @row_repeated = @table.getRowConst(3)
    @row_hidden = @table.getRowConst(11)
  end

  it "should be loaded" do
    refute_nil (@row)
   end

  it "should recognize repeated rows" do
    assert (@row_repeated.repeated?)
    assert_equal(3, @row_repeated.repeated?)
   end

  it "should recognize hidden rows" do
    assert (@row_hidden.hidden?)
    refute (@row_repeated.hidden?)
  end

  it "should show & hide lines" do
    assert (@row_hidden.hidden?)
    @row_hidden.show
    refute (@row_hidden.hidden?)
    @row_hidden.hide
    assert (@row_hidden.hidden?)
  end


  it "should read&write cell" do
    assert_equal("Text", @row[0])
    @row[0] = NEW_TEXT
    assert_equal(NEW_TEXT, @row[0])
   end

  it "should get count of cells in row" do
    assert_equal(5, @row.cellnum)
    assert_equal(5, @row_repeated.cellnum)
   end

  it "should reduce repeated row" do
    assert_equal( 3, @table.getRowConst(3).repeated? )
    @table.delete 3
    assert_equal( 2, @table.getRowConst(3).repeated? )
    @table.delete 3
    refute @table[3].repeated?
   end

  it "should compare rows" do
    # force split
    @table[3,0]=NEW_TEXT
    @table[4,0]=NEW_TEXT
    assert( @table[3] == @table[4] )
   end

end