require File.expand_path(File.dirname(__FILE__) + '/label/batch')

module Pdf
  module Label
    VERSION = '2.0.1'
  
    #We want the barcode fonts to be loaded as availible fonts in the font path
    root = File.expand_path(File.dirname(__FILE__) + "/../../")
    PDF::Writer::FONT_PATH << (root + "/fonts")
    PDF::Writer::FontMetrics::METRICS_PATH << (root + "/fonts")
  end
end