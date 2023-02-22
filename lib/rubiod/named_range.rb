class NamedRange
  attr_reader :spreadsheet

  def initialize(spread, node)
    @spreadsheet = spread
    @x_node = node
    @ref = parseCellReferenz(@x_node["table:base-cell-address"])
  end

  def value
    spreadsheet[*@ref]
  end

  def setValue(val)
    spreadsheet[*@ref] = val
  end

  private

  def parseCellReferenz(str)
    regex = /\$(\w*)\.\$([a-zA-Z]+)\$(\d+)(:\.\$([a-zA-Z]+)\$(\d+))?/ # Ex.: "$Tabelle1.$C$4"  or  "$Tabelle1.$A$2:.$C$4"

    match = regex.match(str)

    return if match.nil? || @spreadsheet[match[1]].nil?

    base = [match[1], match[3].to_i - 1, alphaToNumber(match[2]) - 1]
    base += [match[6].to_i - 1, alphaToNumber(match[5]) - 1] unless match[4].nil?
    base
  end

  def alphaToNumber(al)
    al.downcase.chars.inject(0) { |sum, c| sum * 26 + (c.ord - 96) }
  end
end
