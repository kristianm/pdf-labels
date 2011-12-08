require 'xml/mapping'
require File.expand_path(File.dirname(__FILE__) + '/length_node')

module Pdf
  module Label
    class Alias
    	include XML::Mapping
    	text_node :name, "@name"
    end
  end
end