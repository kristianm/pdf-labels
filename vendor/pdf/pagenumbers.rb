#--
# PDF::Writer for Ruby.
#   http://rubyforge.org/projects/ruby-pdf/
#   Copyright 2003 - 2005 Austin Ziegler.
#
#   Licensed under a MIT-style licence. See LICENCE in the main distribution
#   for full licensing information.
#
# $Id: pagenumbers.rb,v 1.3 2005/10/12 14:41:40 austin Exp $
#++
require 'pdf/writer'

  # This class will create tables with a relatively simple API and internal
  # implementation.
class PDF::PageNumbers
  VERSION = '1.1.4'

    # Creates a page numbering object. The 
  def initialize(x, y, options = {})
    @x  = x
    @y  = y

    @font               = options[:font]
    @font_encoding      = options[:font_encoding]
    @font_size          = options[:font_size]
    @alignment          = options[:alignment] || :left
    @pattern            = options[:pattern] || "<PAGE> of <TOTAL>"
    @first_page_number  = options[:first_page_number] || 1

    @start_pages        = []
    @stop_pages         = []

    yield self if block_given?
  end

    # The +x+ position for the page numbering. This will be used as a
    # relative position based on <tt>#alignment</tt>.
  attr_accessor :x
    # The +y+ position for the page numbering.
  attr_accessor :y
    # The font that will be used for rendering the page numbers. If not
    # specified, the font currently active at the time of page rendering
    # will be used.
  attr_accessor :font
    # The font encoding for rendering page numbers. If not specified, the
    # default font encoding will be used.
  attr_accessor :font_encoding
    # The size of the font for rendering page numbers. If not specified, the
    # current font size at the time of page rendering will be used.
  attr_accessor :font_size
    # The alignment of the page numbers relative to <tt>#x</tt>. The options
    # are <tt>:left</tt> (the text *begins* at <tt>#x</tt>),
    # <tt>:right</tt> (the text *ends* at <tt>#x</tt>), and <tt>:center</tt>
    # (the text *surrounds* <tt>#x</tt>). The default alignment is
    # <tt>:left</tt>.
  attr_accessor :alignment
    # The page numbering pattern object. This object must either be a String
    # or an object that responds to #apply(page, total). String patterns
    # will be searched for <PAGE> and <TOTAL> and these strings will be
    # replaced with the current page number and the total page number values
    # in Arabic (1, 2, 3, 4, ...) numeral values.
    #
    # Pattern objects will have their #apply method called with the current
    # page number and the total page number values. They will be expected to
    # return a String for writing on the page.
    #
    # The default pattern is "<PAGE> of <TOTAL>".
  attr_accessor :pattern
    # The page numbering style. This is a number "generator" object that
    # responds to #[] and returns a string representing that number.
    # Symbolic values <tt>:default</tt>
    # 
    # The
    # values <tt>:arabic</tt> and <tt>:roman</tt>
  attr_accessor :numbering_style
    # The first page number is the value that will be used as the 
    # generic page number reported by the PDF document during rendering.
    # This allows physical page 10 to be presented as page 1.
  attr_accessor :first_page_number

    # Starts page numbering with this page numbering object. The page
    # numbering will begin on +first_page+, which will be either
    # <tt>:this_page</tt> or <tt>:next_page</tt>.
  def start(pdf, first_page = :this_page)
  end

.blist {{{
<b>:this_page</b> will add the object just to the current page.
<b>:all_pages</b> will add the object to the current and all following pages.
<b>:even_pages</b> will add the object to following even pages, including the current page if it is an even page.
<b>:odd_pages</b> will add the object to following odd pages, including the current page if it is an odd page.
<b>:all_following_pages</b> will add the object to the next page created and all following pages.
<b>:following_even_pages</b> will add to the next even page created and all following even pages.
<b>:following_odd_pages</b> will add to the next odd page created and all following odd pages.
.endblist }}}

  def restart_numbering(pdf, page = :this_page)
  end

  def stop_on_current_page(pdf)
  end

  def stop_on_next_page(pdf)
  end

    # 
  def start(pdf, on_page = :current)
  end
  
  def stop(pdf, on_page = :next)
  end

  def render(pdf, debug = false)
  end

    # Put page numbers on the pages from the current page. Place them
    # relative to the coordinates <tt>(x, y)</tt> with the text horizontally
    # relative according to +pos+, which may be <tt>:left</tt>,
    # <tt>:right</tt>, or <tt>:center</tt>. The page numbers will be written
    # on each page using +pattern+.
    #
    # When +pattern+ is rendered, <PAGENUM> will be replaced with the
    # current page number; <TOTALPAGENUM> will be replaced with the total
    # number of pages in the page numbering scheme. The default +pattern+ is
    # "<PAGENUM> of <TOTALPAGENUM>".
    #
    # If +starting+ is non-nil, this is the first page number. The number of
    # total pages will be adjusted to account for this.
    #
    # Each time page numbers are started, a new page number scheme will be
    # started. The scheme number will be returned.
  def start_page_numbering(x, y, size, pos = nil, pattern = nil, starting = nil)
    pos     ||= :left
    pattern ||= "<PAGENUM> of <TOTALPAGENUM>"

    @page_numbering ||= []
    @page_numbering << (o = {})

    page    = @pageset.size
    o[page] = {
      :x        => x,
      :y        => y,
      :pos      => pos,
      :pattern  => pattern,
      :starting => starting,
      :size     => size
    }
    @page_numbering.index(o)
  end

    # Given a particular generic page number +page_num+ (numbered
    # sequentially from the beginning of the page set), return the page
    # number under a particular page numbering +scheme+. Returns +nil+ if
    # page numbering is not turned on.
  def which_page_number(page_num, scheme = 0)
    return nil unless @page_numbering

    num = 0
    start = start_num = 1

    @page_numbering[scheme].each do |kk, vv|
      if kk <= page_num
        if vv.kind_of?(Hash)
          unless vv[:starting].nil?
            start = vv[:starting]
            start_num = kk
            num = page_num - start_num + start
          end
        else
          num = 0
        end
      end
    end
    num
  end

    # Stop page numbering. Returns +false+ if page numbering is off.
    #
    # If +stop_total+ is true, then then the totaling of pages for this page
    # numbering +scheme+ will be stopped as well. If +stop_at+ is
    # <tt>:current</tt>, then the page numbering will stop at this page;
    # otherwise, it will stop at the next page.
  def stop_page_numbering(stop_total = false, stop_at = :current, scheme = 0)
    return false unless @page_numbering

    page = @pageset.size

    if stop_at != :current and @page_numbering[scheme][page].kind_of?(Hash)
      if stop_total
        @page_numbering[scheme][page]["stoptn"] = true
      else
        @page_numbering[scheme][page]["stopn"] = true
      end
    else
      if stop_total
        @page_numbering[scheme][page] = "stopt"
      else
        @page_numbering[scheme][page] = "stop"
      end

      @page_numbering[scheme][page] << "n" unless stop_at == :current
    end
  end

  def page_number_search(label, tmp)
    tmp.each do |scheme, v|
      if v.kind_of?(Hash)
        return scheme unless v[label].nil?
      else
        return scheme if v == label
      end
    end
    0
  end
  private :page_number_search

  def add_page_numbers
      # This will go through the @page_numbering array and add the page
      # numbers are required.
    unless @page_numbering.nil?
      total_pages1 = @pageset.size
      tmp1 = @page_numbering
      status = 0
      info = {}
      tmp1.each do |tmp|
          # Do each of the page numbering systems. First, find the total
          # pages for this one.
        k = page_number_search("stopt", tmp)
        if k and k > 0
          total_pages = k - 1
        else
          l = page_number_search("stoptn", tmp)
          if l and l > 0
            total_pages = l
          else
            total_pages = total_pages1
          end
        end
        @pageset.each_with_index do |id, page_num|
          next if page_num == 0
          if tmp[page_num].kind_of?(Hash) # This must be the starting page #s
            status = 1
            info = tmp[page_num]
            if info[:starting]
              info[:delta] = info[:starting] - page_num
            else
              info[:delta] = page_num
            end
              # Also check for the special case of the numbering stopping
              # and starting on the same page.
            status = 2 if info["stopn"] or info["stoptn"]
          elsif tmp[page_num] == "stop" or tmp[page_num] == "stopt"
            status = 0 # we are stopping page numbers
          elsif status == 1 and (tmp[page_num] == "stoptn" or tmp[page_num] == "stopn")
            status = 2
          end

          if status != 0
              # Add the page numbering to this page
            unless info[:delta]
              num = page_num
            else
              num = page_num + info[:delta]
            end

            total = total_pages + num - page_num
            pat = info[:pattern].gsub(/<PAGENUM>/, num.to_s).gsub(/<TOTALPAGENUM>/, total.to_s)
            reopen_object(id.contents.first)

            case info[:pos]
            when :left    # Write the page number from x.
              w = 0
            when :right   # Write the page number to x.
              w = text_width(pat, info[:size])
            when :center  # Write the page number around x.
              w = text_width(pat, info[:size]) / 2.0
            end
            add_text(info[:x] - w, info[:y], pat, info[:size])
            close_object
            status = 0 if status == 2
          end
        end
      end
    end
  end
  private :add_page_numbers

end
