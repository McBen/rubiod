require 'test_helper'

describe "NamedExpressions" do

  before do
    @spread = Rubiod::Spreadsheet.new('test/fixtures/doc1.ods')
    @labels = @spread.labels
  end


  it "should read fixture fields" do
    refute_nil(@labels)

    refute_nil(@labels.names.index("TheFirstCell"))
   end

  it "should read&write field value" do
    assert_equal("Here",@labels["TheFirstCell"])

    @labels["TheFirstCell"]="new text"
    assert_equal("new text",@labels["TheFirstCell"])
   end

end
