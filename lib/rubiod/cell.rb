module Rubiod

  class Cell

    def initialize row, x_cell
      @row = row
      @x_cell = x_cell
    end

    attr_reader :row

    def repeated?
      rep = @x_cell.attr('table:number-columns-repeated')
      rep && rep.to_i
    end

    def style_name
      @x_cell.attr('table:style-name')
    end

    def no_data?
      repeated? || @x_cell.children.empty?
    end

    def data
      no_data? ? nil : @x_cell.child.content
    end

    # TODO: maybe, remove only value-type and value
    # removes all current attributes (except style-name) and content
    def set_data data
      old_style = @x_cell['table:style-name']

      @x_cell.attributes.clear
      @x_cell.children.remove

      @x_cell['table:style-name']=old_style unless old_style.nil?
      @x_cell['office:value-type']='string'

      value = Nokogiri::XML::Node.new('text:p',@x_cell)
      value.content = data
      @x_cell << value
    end

    def ==(otherCell)
      return (data==otherCell.data && style_name==otherCell.style_name)
    end

    #############################
    # Managed Object
    private

      def duplicate
        new_cell = Nokogiri::XML::Node.new('table:table-cell',@x_cell.document)
        new_cell['table:style-name'] = @x_cell['table:style-name']

        @x_cell.add_next_sibling(new_cell)
        Cell.new(@row, new_cell)
      end

      def delete!
        @x_cell.remove!
      end

      def setCount rep
        if rep > 1 then
          @x_cell['number-columns-repeated']=rep
        else
          @x_cell.remove_attribute 'number-columns-repeated'
        end
      end
  end

end
