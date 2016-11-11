module Rubiod

  class Spreadsheet < Document

    attr_reader :labels
    attr_reader :worksheets

    def initialize string_or_io
      super

      @x_content = Zip::File.open(@filename) do |zip|
        Nokogiri::XML( zip.get_input_stream('content.xml') )
      end

      x_spread = @x_content.xpath '//office:spreadsheet'

      @worksheets = {}
      x_spread.xpath('table:table').each_with_index do |node,i|
        ws = Worksheet.new(self, node)
        @worksheets[node['table:name']] = ws
        @worksheets[i] = ws
      end

      @labels = NamedExpressions.new(self, x_spread)
      @recalculationsForced = false
    end

    def save path=nil
      ::File.open(path || @filename, "wb") {|f| f.write( generate ) }
    end

    def generate
      buffer = Zip::OutputStream.write_buffer do |out|

        Zip::File.open(@filename) do |file|
          file.each do |entry|

            next if entry.directory?
            entry.get_input_stream do |is|

              data = is.sysread
              data = @x_content.to_xml(indent: 0) if entry.name=='content.xml'
                
              out.put_next_entry(entry.name)
              out.write data
            end
          end
        end
      end

      buffer.string
    end

    def worksheet_names
      @worksheets.keys.reject { |k| k.kind_of? Numeric }
    end

    def [] ws_index_or_name, *rest_indexes
      if rest_indexes.empty?
        @worksheets[ws_index_or_name]
      else
        @worksheets[ws_index_or_name][*rest_indexes]
      end
    end

    def []= ws_index_or_name, row, col, val
      @worksheets[ws_index_or_name][row, col] = val
    end

    def needRecalculation
      clearFormulaResults
    end

    private
      def clearFormulaResults
        return if @recalculationsForced


        path = '//office:document-content/office:body/office:spreadsheet/table:table/table:table-row/table:table-cell[@table:formula]'
        @x_content.xpath(path).each() { | item |  

          # to force recalculation of formulas we 1) set all expressions to 'error'
          item['calcext:value-type']= "error"

          # to force recalculation of formulas we 2) clear the text result
          item.xpath('text:p').each() { |text|  
            p "removed"
            text.remove
          }
        }

        @recalculationsForced = true
      end

  end

end
