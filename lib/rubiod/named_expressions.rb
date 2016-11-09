
class NamedExpressions

  def initialize(spread, x_spread)

    x_exp = x_spread.xpath('table:named-expressions')

    @namedRange = {}
    return if x_exp.nil?
    x_exp[0].xpath('table:named-range').each { |node|
      @namedRange[node['table:name']] = NamedRange.new(spread, node)
    }
  end


  def names
    @namedRange.keys
  end

  def get(key)
    @namedRange[key]
  end

  def [] (key)
    @namedRange[key] && @namedRange[key].value
  end

  def []= (key,val)
    @namedRange[key] && @namedRange[key].setValue(val)
  end

end