module Rubiod

  class Row

    def initialize worksheet, x_row
      @worksheet = worksheet
      @x_row = x_row

      @cell_refs = ManagedIntervalArray.new

      @x_row.children.each do |x_cell|
        cell = Cell.new(self, x_cell)
        count = cell.repeated? || 1
        @cell_refs.add cell, count
      end
    end

    attr_reader :worksheet, :cell_refs

    def repeated?
      rep = @x_row['table:number-rows-repeated']
      rep && rep.to_i
    end

    def hidden?
      @x_row['table:visibility'] == 'collapse'
    end

    def hide
      @x_row['table:visibility'] = 'collapse'
    end

    def show
      @x_row.remove_attribute('visibility')
    end

    def [] ind
      cell = @cell_refs[ind]
      cell && cell.data
    end

    def []= ind, val
      cell = @cell_refs.prepareForChange(ind)
      cell.set_data val
    end

    def cellnum
      @cell_refs.size
    end
    
    def optimize
      @cell_refs.optimize
    end



    #############################
    # Managed Object
    def ==(otherRow)
      return @cell_refs==otherRow.cell_refs
    end

    private

      def duplicate
        insert_after
      end


      def insert_after
        new_row = @x_row.dup
        @x_row.add_next_sibling(new_row)
        
        # start_cur_index = 0 # index of first cell with current style
        # cur_style = @cell_refs[0].style_name
        # @cell_refs.each do |index, cell|
        #   new_style = cell.style_name

        #   if cur_style != new_style
        #     add_cell(@x_row.next, cur_style, index-start_cur_index)
        #     start_cur_index = index
        #     cur_style = new_style
        #   end
        # end
        # add_cell(new_row, cur_style, @cell_refs.size - start_cur_index )

        Row.new(@worksheet, new_row)
      end

      def add_cell row, style, count
        opts = {}
        opts[:style_name] = style if style
        opts[:repeated] = count if count > 1

        @x_row.next << Cell.new_empty_x(@x_row.doc, opts)
      end


      def delete!
        @x_row.remove
      end

      def setCount rep
        if rep > 1 then
          @x_row['table:number-rows-repeated']=rep
        else
          @x_row.remove_attribute 'number-rows-repeated'
        end
      end

  end
end
