module Rubiod

  class Cell

    # options [Hash] -
    #   :repeated => [Integer] # specify to create repeated cell
    #   :style_name => [String] # specify to set style
    def self.new_empty_x doc, options={}
        attr_hash = {}
        attr_hash['table:style-name'] = options[:style_name]            unless options[:style_name].nil? || options[:style_name].empty?
        attr_hash['table:number-columns-repeated'] = options[:repeated] if options[:repeated] && options[:repeated]>1

        doc.ns_create_node 'table:table-cell', nil, attr_hash
    end


    def initialize row, x_cell
      @row = row
      @x_cell = x_cell
    end

    attr_reader :row

    def repeated?
      rep = @x_cell['number-columns-repeated']
      rep && rep.to_i
    end

    def style_name
      @x_cell['style-name']
    end

    def no_data?
      repeated? || @x_cell.ns_elements.empty?
    end

    def data
      no_data? ? nil : @x_cell.ns_elements.first.content # TODO: improve
    end

    # TODO: maybe, remove only value-type and value
    # removes all current attributes (except style-name) and content
    def set_data data
      @x_cell.each_attr do |a|
        a.remove! unless a.name == 'style-name' # TODO: ns equality check
      end
      @x_cell.each(&:remove!)
      @x_cell.ns_set_attr 'office:value-type', 'string'
      @x_cell << @x_cell.doc.ns_create_node('text:p', data)
      data
    end


    #############################
    # Managed Object
    private

      def duplicate
        @x_cell.next = Cell.new_empty_x @x_cell.doc, {style_name: style_name}
        Cell.new(@row, @x_cell.next)
      end

      def delete!
        @x_cell.remove!
      end

      def setCount rep
        @x_cell.ns_remove_attr 'table:number-columns-repeated'
        if rep > 1 then
          @x_cell.ns_set_attr 'table:number-columns-repeated', rep
        end
      end

  end

end
