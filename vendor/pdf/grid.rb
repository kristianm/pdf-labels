#! /usr/bin/env ruby
#--
# PDF::Writer for Ruby.
#   http://rubyforge.org/projects/ruby-pdf/
#   Copyright 2003 - 2005 Austin Ziegler.
#
#   Licensed under a MIT-style licence. See LICENCE in the main distribution
#   for full licensing information.
#
# $Id: grid.rb,v 1.2 2005/08/12 03:19:44 austin Exp $
#++
require 'pdf/writer'

class PDF::Grid
    # The scale of the grid lines in one direction. The scale always starts
    # from the top or left of the page, depending on whether this is the X
    # axis or Y axis. Minor lines are drawn before major lines.
  class Scale
    def initialize
      @initial_gap  = 0

      yield self if block_given?
    end

      # The initial gap between the top or left of the page and the first
      # grid line.
    attr_accessor :initial_gap
      # Major grid line style. The default is unset, which uses the current
      # line style.
    attr_accessor :major_style
      # Major grid line colour. The default is unset, which uses the current
      # line colour.
    attr_accessor :major_color
      # The number of units between each major line.
    attr_accessor :major_step
      # Minor grid line style. The default is unset, which uses the current
      # line style.
    attr_accessor :minor_style
      # Minor grid line colour. The default is unset, which uses the current
      # line colour.
    attr_accessor :minor_color
      # The number of units between each minor line.
    attr_accessor :minor_step
  end

  def initialize
    yield self if block_given?
  end

    # The X axis scale of the grid. X axis lines are drawn first.
  attr_accessor :x_scale
    # The Y axis scale of the grid. X axis lines are drawn first.
  attr_accessor :y_scale

    # Renders the grid on the document.
  def render_on(pdf)
    pdf.save_state

    if @x_scale.minor_step and @x_scale.minor_step > 0
      pdf.stroke_color! @x_scale.minor_color if @x_scale.minor_color
      pdf.stroke_style! @x_scale.minor_style if @x_scale.minor_style

      start = @x_scale.initial_gap
      step  = @x_scale.minor_step

      start.step(pdf.page_width, step) do |x|
        line(x, 0, x, pdf.page_height).stroke
      end
    end

    if @y_scale.minor_step and @y_scale.minor_step > 0
      pdf.stroke_color! @y_scale.minor_color if @y_scale.minor_color
      pdf.stroke_style! @y_scale.minor_style if @y_scale.minor_style

      start = pdf.page_height - @y_scale.initial_gap
      step  = -@y_scale.minor_step

      start.step(0, step) do |y|
        line(0, y, pdf.page_width, y).stroke
      end
    end

    if @x_scale.major_step and @x_scale.major_step > 0
      pdf.stroke_color! @x_scale.major_color if @x_scale.major_color
      pdf.stroke_style! @x_scale.major_style if @x_scale.major_style

      start = @x_scale.initial_gap
      step  = @x_scale.major_step

      start.step(pdf.page_width, step) do |x|
        line(x, 0, x, pdf.page_height).stroke
      end
    end

    if @y_scale.major_step and @y_scale.major_step > 0
      pdf.stroke_color! @y_scale.major_color if @y_scale.major_color
      pdf.stroke_style! @y_scale.major_style if @y_scale.major_style

      start = pdf.page_height - @y_scale.initial_gap
      step  = -@y_scale.major_step

      start.step(0, step) do |y|
        line(0, y, pdf.page_width, y).stroke
      end
    end

#   stroke_color(Color::::RGB::Grey60)
#   y = absolute_top_margin
#   line(0, y, @page_width, y).stroke
#   line(0, @bottom_margin, @page_width, @bottom_margin).stroke
#   line(@left_margin, 0, @left_margin, @page_height).stroke
#   x = absolute_right_margin
#   line(x, 0, x, @page_height).stroke
#   y = @page_height / 2.0
#   line(0, y, @left_margin, y).stroke
#   x = absolute_right_margin
#   line(x, y, @page_width, y).stroke
#   x = @page_width / 2.0
#   line(x, 0, x, @bottom_margin).stroke
#   y = absolute_top_margin
#   line(x, y, x, @page_height).stroke

#   0.step(@page_width, 10) do |x|
#     add_text(x, 0, 3, x.to_s)
#     add_text(x, @page_height - 3, 3, x.to_s)
#   end

#   0.step(@page_height, 10) do |y|
#     add_text(0, y, 3, y.to_s)
#     add_text(@page_width - 5, y, 3, y.to_s)
#   end

    restore_state
  end
end
