require File.expand_path(File.dirname(__FILE__) + '/length_node')

module Pdf
  module Label
    class Layout
    	include XML::Mapping
    	numeric_node :nx, "@nx"
    	numeric_node :ny, "@ny"
    	length_node :x0, "@x0", :default_value => "0 pt"
    	length_node :y0, "@y0", :default_value => "0 pt"
    	length_node :dx, "@dx", :default_value => "0 pt"
    	length_node :dy, "@dy", :default_value => "0 pt"
    end
  end
end