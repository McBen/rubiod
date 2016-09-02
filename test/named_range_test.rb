require 'test_helper'

describe "NamedRange" do

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @labels = @spread.labels
    @firstCell = @labels.get('TheFirstCell')

    @private_methods = NamedRange.private_instance_methods
    NamedRange.send(:public, *@private_methods)
  end

  after do
    NamedRange.send(:private, *@private_methods)
    @private_methods = nil
  end


  it "should parse cell ref string" do
    assert_equal(["Tabelle1",2,3], @firstCell.parseCellReferenz("$Tabelle1.$C$4"))
    assert_equal(["Tabelle1",0,1,2,3], @firstCell.parseCellReferenz("$Tabelle1.$A$2:.$C$4"))
  end

  it "should convert alpha to number" do
    assert_equal(2, @firstCell.alphaToNumber("b"))
    assert_equal(26, @firstCell.alphaToNumber("z"))
    assert_equal(27, @firstCell.alphaToNumber("AA"))
  end

  it "should get value of cell" do
    assert_equal("Here",@firstCell.value)
  end

  it "should get write to calle" do
    @firstCell.setValue("new value")
    assert_equal("new value",@firstCell.value)
  end

end
