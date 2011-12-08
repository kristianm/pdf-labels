#--
# PDF::Writer for Ruby.
#   http://rubyforge.org/projects/ruby-pdf/
#   Copyright 2003 - 2005 Austin Ziegler.
#
#   Licensed under a MIT-style licence. See LICENCE in the main distribution
#   for full licensing information.
#
# $Id: info.rb,v 1.5 2005/10/12 14:41:41 austin Exp $
#++

require 'set'

  # Define the document information -- metadata.
class PDF::Writer::Object::Info < PDF::Writer::Object
  @types = Set.new
  @types << "CreationDate"
  @types << "Creator"
  @types << "Title"
  @types << "Author"
  @types << "Subject"
  @types << "Keywords"
  @types << "ModDate"
  @types << "Trapped"
  @types << "Producer"

  class << self
    attr_reader :types

    def add_type(type)
      @types << type.to_s
      attr_accessor type.to_s.downcase.to_sym
    end
  end

  def initialize(parent)
    super(parent)

    @parent.instance_variable_set('@info', self)

    @creationdate = Time.now
    @creator      = File.basename($0)
    @producer     = "PDF::Writer for Ruby"
    @title        = nil
    @author       = nil
    @subject      = nil
    @keywords     = nil
    @moddate      = nil
    @trapped      = nil
  end

  @types.each do |type|
    attr_accessor type.to_s.downcase.to_sym
  end

  def to_s
    @parent.arc4.prepare(self) if @parent.encrypted?
    res = "\n#{@oid} 0 obj\n<<\n"
    self.class.types.each do |type|
      val = __send__(type.to_s.downcase.to_sym)
      next if val.nil?

      res << "/#{type} ("
      if val.kind_of?(Time)
        s = "D:%04d%02d%02d%02d%02d"
        val = val.utc
        val = s % [ val.year, val.month, val.day, val.hour, val.min ]
      end

      if @parent.encrypted?
        res << PDF::Writer.escape(@parent.arc4.encrypt(val))
      else
        res << PDF::Writer.escape(val)
      end
      res << ")\n"
    end
    res << ">>\nendobj"
  end
end
