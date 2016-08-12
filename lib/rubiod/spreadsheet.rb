module Rubiod

  class Spreadsheet < Document

    def initialize string_or_io
      super

      @x_content = Zip::File.open(@filename) do |zip|
        LibXML::XML::Document.io zip.get_input_stream('content.xml')
      end

      x_spread = @x_content.find_first '//office:spreadsheet'
      x_tabs_with_index = x_spread.ns_elements.each_with_index
      @worksheets = x_tabs_with_index.inject({}) do |wss, (x_tab, i)|
        ws = Worksheet.new(self, x_tab)
        wss[x_tab['name']] = ws
        wss[i] = ws
        wss
      end
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
              data = @x_content.to_s(indent: false) if entry.name=='content.xml'
                
              out.put_next_entry(entry.name)
              out.write data
            end
          end
        end
      end

      buffer.string
    end


    attr_reader :worksheets

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

  end

end
