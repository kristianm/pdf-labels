# -*- ruby -*-

ENV['RUBY_FLAGS'] = "-I#{%w(lib test vendor).join(File::PATH_SEPARATOR)}"
require 'rubygems'
require 'hoe'
require './lib/pdf/label'

#Ryan, if you want to have strong opinions thats cool, but if you want to be a prick about it, you'd better be right... and your not
class Hoe
  def extra_deps
    @extra_deps.reject do |x|
      Array(x).first == 'hoe'
    end
  end
end

Hoe.new('pdf-labels', Pdf::Label::VERSION) do |p|    
  p.rubyforge_name = 'pdf-labels'
  p.author = 'Rob Kaufman'
  p.email = 'rgkaufman@gmail.com'
  p.summary = 'Easy label creation in Ruby through PDF::Writer and using templates from gLabels. Contains the library pdf_labels, the Rails engine LabelPageEngine and an example application FileClerk.'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

task :clean do
  dir = Dir.new(Dir.pwd)
  dir.grep(/pdf$/) {|file| rm file}
end
