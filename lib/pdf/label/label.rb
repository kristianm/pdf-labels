require File.expand_path(File.dirname(__FILE__) + '/length_node')
require File.expand_path(File.dirname(__FILE__) + '/layout')
require File.expand_path(File.dirname(__FILE__) + '/markup')

module Pdf
  module Label

    class Label
      include XML::Mapping
      attr_accessor :shape
      numeric_node :id, "@id"
      array_node :markupMargins, "Markup-margin", :class => MarkupMargin, :default_value => nil
      array_node :markupLines, "Markup-line", :class => MarkupLine, :default_value => nil
      array_node :markupCircles, "Markup-circle", :class => MarkupCircle, :default_value => nil
  
      array_node :layouts, "Layout", :class => Layout

      def markups
        @markups = Hash.new
        @markups = @markups.merge @markupMargins
        @markups = @markups.merge @markupLines
        @markups = @markups.merge @markupCircles
        @markups
      end

    end



    class LabelRectangle < Label
      length_node :width, "@width"
      length_node :height, "@height" 
      length_node :round, "@round", :default_value => "0 pt"
      length_node :waste, "@waste", :default_value => "0 pt"
      length_node :x_waste, "@x_waste", :default_value => "0 pt"
      length_node :y_waste, "@y_waste", :default_value => "0 pt"
      @kind = "Rectangle"	
    end

    class LabelRound < Label
      length_node :radius, "@radius"
      length_node :waste, "@radius", :default_value => "0 pt"
      @kind = "Round"
    end

    class LabelCD < Label
      length_node :radius, "@radius" 
      length_node :hole, "@hole"
      length_node :width, "@width", :default_value => ""
      length_node :height, "@height", :default_value => ""
      length_node :waste, "@waste", :default_value => ""
      @kind = "CD"		
    end
  end
end