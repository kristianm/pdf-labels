$: << File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'test/unit'
require 'pdf/label'

class TestPdfLabelBatch < Test::Unit::TestCase
  ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
  def setup
  end

  def test_new_with_tempalte_name
    p = Pdf::Label::Batch.new("Avery  5366")
    assert p
    assert_equal p.template.name, "Avery  5366"
  end

  def test_new_with_alias_name
    p = Pdf::Label::Batch.new("Avery  8166")
    assert p
    assert_equal p.template.name, "Avery  5366"
  end
  
  def test_new_with_paper_type
    p = Pdf::Label::Batch.new("Avery  5366", {:paper => 'Legal'})
    assert p
    assert_equal p.pdf.page_width, 612.0
    assert_equal p.pdf.page_height, 1008.0
  end

  def test_new_with_tempalte_not_found
    assert_raise(RuntimeError) {
      p = Pdf::Label::Batch.new("Some Non-Existing")
    }
  end
  
  #TODO other options are possible for pdf_options, we need to test those at some point
  
  def test_PdfLabelBatch_load_tempalte_set
    Pdf::Label::Batch.load_template_set("#{ROOT}/templates/avery-iso-templates.xml")
     #Avery   7160 is found in avery-iso-templates
     p = Pdf::Label::Batch.new("Avery   7160")
     assert p
     assert_equal p.pdf.page_width, 595.28
     assert_equal p.pdf.page_height, 841.89
     Pdf::Label::Batch.load_template_set("#{ROOT}/templates/avery-us-templates.xml")
   end
   
   def test_PdfLabelBatch_all_template_names
     #what happens if we havn't loaded a template yet?
     t = Pdf::Label::Batch.all_template_names
     assert t
     assert_equal t.class, Array
     assert_equal t.size, 291
     assert_equal t[0], "Avery  3274.1"
   end
     

  def test_add_label_3_by_10
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 10
    p.add_label() # should add to col 1, row 1
    p.add_label(:position => 1) # should add col 1, row 2
    p.add_label(:text => "Positoin 15", :position => 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label(:use_margin => true, :position => 4)
    #with out the margin?
    p.add_label(:text => 'No Margin', :position => 5, :use_margin => false)
    p.add_label(:position => 7, :text => 'This is the song that never ends, yes it goes on and on my friends')
    p.add_label(:position => 9, :text => "X Offset = 4, Y Offset = -6", :offset_x => 4, :offset_y => -6)
    p.add_label(:text => "Centered", :position => 26, :justification => :center) # should add col 2, row 15
    p.add_label(:text => "[Right justified]", :justification => :right, :position => 28)# col 2, row 14, right justified.
    p.add_label(:position => 29) # should add col 2, row 15
    p.add_label(:position => 8, :text => "This was added last and has a BIG font", :font_size => 16)
    p.add_label(:position => 8, :text => "This was added last and has a small font", :font_size => 8, :offset_y => -40)
    p.draw_boxes(false, true)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_label_output.pdf")
  end
  
  def test_add_label_3_by_10_multi_page
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 10
    p.add_label() # should add to col 1, row 1
    p.add_label(:position => 1) # should add col 1, row 2
    p.add_label(:text => "Positoin 15", :position => 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label(:use_margin => true, :position => 4)
    #with out the margin?
    p.add_label(:text => 'No Margin', :position => 5, :use_margin => false)
    p.add_label(:position => 48, :text => "This should be on a new page")
    p.add_label(:position => 30, :text => "This should be first a page 2")
    p.draw_boxes(false, true)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_multi_page.pdf")
  end
    
  
  def test_add_many_labels
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 10
    #without positoin, so start at 1
    p.add_many_labels(:text => "Hello Five Times!", :count => 5)
    p.add_many_labels(:text => "Hellow four more times, starting at 15", :count => 4, :position => 15)
    p.save_as("#{ROOT}/test_add_many_label_output.pdf")
  end
  
  def test_draw_boxes
    p = Pdf::Label::Batch.new("Avery  5366") # label is 2 x 10
    p.draw_boxes
    p.save_as("#{ROOT}/test_draw_boxes_output.pdf")
  end
  
  def test_font_path
    font_path = "#{ROOT}/fonts"
    assert PDF::Writer::FontMetrics::METRICS_PATH.include?(font_path)
    assert PDF::Writer::FONT_PATH.include?(font_path)
  end
  
  def test_set_and_get_barcode_font
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 10
    assert_equal "Code3de9.afm", p.barcode_font
    
    assert p.barcode_font = "CodeDatamatrix.afm"
    assert_equal "CodeDatamatrix.afm", p.barcode_font
    
    assert_raise(RuntimeError) do
      p.barcode_font = "CodeBob"
    end
    assert_equal "CodeDatamatrix.afm", p.barcode_font
    
  end
  
  def test_add_barcode_label
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 2
    i = 0
    Pdf::Label::Batch.all_barcode_fonts.each_key do |font_name|
      p.barcode_font = font_name
      p.add_label(:text => font_name, :position => i)
      i += 1
      p.add_barcode_label(:bar_text => "Hello", :bar_size => 32, :text => "HELLO", :position => i)
      i += 1
      p.add_barcode_label(:text => "*1234567890*", :position => i,  :bar_size => 32)
      i += 1
    end
    p.save_as("#{ROOT}/test_barcode_output.pdf")
  end
  
  def test_code39
    p = Pdf::Label::Batch.new("Avery  8160") # label is 2 x 2
    assert_equal "*HELLO123*", p.code39("hellO123")
  end
 
end
