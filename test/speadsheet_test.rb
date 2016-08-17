require 'test_helper'


describe "Spreadsheet" do

  SHEET_NAME="Tabelle1"
  SHEET2_NAME="Tabelle2"

  it "should fail to open file" do
    assert_raises Zip::Error do 
      Rubiod::Spreadsheet.new('not_existing.ods')
    end
   end


  it "should open file" do
    refute_nil Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
   end


  it "should save file" do
    tmp_file = 'tmp/delme.ods'
    begin File.delete(tmp_file) rescue nil end

    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    spread.save(tmp_file)

    assert File.exist?( tmp_file )

    File.delete(tmp_file)
   end


  it "should generate file data" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    refute_nil( spread.generate )
   end


  it "should give worksheet names" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    # TODO: remove 'nil' 
    assert_equal( [nil,SHEET_NAME, SHEET2_NAME], spread.worksheet_names ) 
    assert_equal( 3, spread.worksheet_names.count ) 
   end


  it "should give a table by names" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    sheet = spread[SHEET_NAME]
    assert_kind_of(Rubiod::Worksheet, sheet)
   end


  it "should give a table by number" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    sheet = spread[1]
    assert_kind_of(Rubiod::Worksheet, sheet)
   end


  it "should read a cell" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    cell = spread[SHEET_NAME, 1, 0]
    assert_equal( "Some", cell )

    cell = spread[2, 0, 0]
    assert_equal( "OnPage2", cell )
   end


  it "should write a cell" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    spread[SHEET_NAME, 1, 0] = "test"
    assert_equal( "test", spread[SHEET_NAME, 1, 0] )
  end


  it "should write cell or give error" do
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    spread[SHEET_NAME, 15, 1] = "test"
    assert_equal( "test", spread[SHEET_NAME, 15, 1] )
  end


  it "generate bunch of test docs" do
    tmp_dir = 'tmp/'
    spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')

    spread.save(tmp_dir+"file_01.ods")

    tab = spread[1]

    tab[0,0] = "First cell write"
    spread.save(tmp_dir+"file_02_cell_write.ods")

    tab[0,0] = "written text to repeated row 4"
    tab[4,0] = "Insert_in repeated"
    spread.save(tmp_dir+"file_03_row_split.ods")

    tab[0,0] = "deleted row 3"
    tab.delete 3
    spread.save(tmp_dir+"file_04_row_delete.ods")

    tab[0,0] = "insert 5 rows at 2"
    tab.insert 2,5
    spread.save(tmp_dir+"file_05_row_insert.ods")

    tab[0,0] = "write text to 4 and removed row 3"
    tab[4,0] = "new_rows_splitted"
    tab.delete 3
    spread.save(tmp_dir+"file_06_split_and_delete.ods")
   end

end

