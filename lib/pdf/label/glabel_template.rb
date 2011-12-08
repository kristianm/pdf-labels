require File.expand_path(File.dirname(__FILE__) + '/template')
module Pdf
  module Label
    class GlabelsTemplate
      include XML::Mapping
  
      hash_node :templates, "Template", "@name", :class => Template, :default_value => Hash.new
  
      def find_all_templates
        return @t unless @t.nil?
        @t = []
        templates.each {|t|
          @t << "#{t[1].name}"
          t[1].alias.each {|a|
            @t << "#{a[1].name}"
          }
        }
        return @t
      end
        

      def find_template(t_name)
        return find_all_with_templates if t_name == :all
        if t = templates[t_name]
          return t
        else
          templates.each { |t|
            if t[1].alias[t_name]
              return t[1]
            end
          }
        end
        return nil
      end

    end
  end
end