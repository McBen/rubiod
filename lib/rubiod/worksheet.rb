
module Rubiod
  class Worksheet
    def initialize(spreadsheet, x_table)
      @spreadsheet = spreadsheet
      @x_table = x_table

      @row_refs = ManagedIntervalArray.new

      @x_table.xpath("table:table-row").each do |x_row|
        row = Row.new(self, x_row)
        count = row.repeated? || 1
        @row_refs.add row, count
      end
    end

    attr_reader :spreadsheet

    # readonly access for Row
    def getRowConst(row)
      @row_refs[row]
    end

    def [](row, col = nil)
      col.nil? ? @row_refs.prepareForChange(row) : @row_refs[row][col]
    end

    def []=(row, col, val)
      rw = @row_refs.prepareForChange(row)
      rw[col] = val
    end

    # inserts a row after specified, copying last's formatting
    # return new row or nil
    def insert(row_ind, count = 1)
      @row_refs.insert(row_ind, count)
    end

    # deletes specified row
    def delete(row_ind)
      @row_refs.delete(row_ind)
    end

    def get_row_count
      @row_refs.size
    end

    def each
      (0...@row_refs.size).each{ |row| yield(@row_refs.prepareForChange(row),row)  }
    end

    def modifiyRange(range)
      @row_refs.modifiyRange(range, &Proc.new)
    end

    def optimize
      @row_refs.each { |_, r| r.optimize }
      @row_refs.optimize
    end

    def needRecalculation
      @spreadsheet.needRecalculation
    end
  end
end
