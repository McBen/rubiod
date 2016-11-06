#--
# Copyright (c) 2011 Eugen Okhrimenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++

require 'nokogiri'

require 'zip'
require 'fileutils'

module Rubiod
  require 'rubiod/version'

  require 'rubiod/managed_interval_array'

  require 'rubiod/document'
  require 'rubiod/spreadsheet'
  require 'rubiod/worksheet'
  require 'rubiod/named_range'
  require 'rubiod/named_expressions'
  require 'rubiod/row'
  require 'rubiod/cell'

  @tmp_dir = '/tmp'
  class << self
    attr_accessor :tmp_dir
  end
end
