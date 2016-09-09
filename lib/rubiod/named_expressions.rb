
class NamedExpressions

  def initialize(spread, x_spread)

    x_exp = x_spread.ns_elements_by_name('named-expressions')

    @namedRange = {}
    x_exp.first.ns_elements_by_name('named-range').each { |node|
      @namedRange[node['name']] = NamedRange.new(spread, node)
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