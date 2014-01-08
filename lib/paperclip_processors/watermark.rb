module Paperclip
  class Watermark < Processor

    attr_accessor :whiny, :watermark_path, :position
    
    def initialize file, options = {}, attachment = nil
      super

      @file               = file
      @basename           = File.basename(@file.path)
      @whiny              = options[:whiny] ||= true
      @watermark_path     = options[:watermark_path]
      @position           = options[:position] ||= "South"
      @target_geometry    = Geometry.from_file file
      @watermark_geometry = Geometry.from_file @watermark_path
    end

    def make
      src = @file
      dst = Tempfile.new(@basename)
      dst.binmode
      
      watermark = <<-end_watermark
        #{@watermark_path} -extract #{@target_geometry.width.to_i}x#{@target_geometry.height.to_i}+#{@watermark_geometry.height.to_i/2}+#{@watermark_geometry.width.to_i/2}
      end_watermark
      
      command = "composite"
      params = <<-end_params
        -gravity #{@position} #{watermark} "#{ File.expand_path(src.path) }[0]" "#{ File.expand_path(dst.path) }[0]"
      end_params

      begin
        success = Paperclip.run(command, params.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        #raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
        raise PaperclipError, command + params if @whiny
      end

      dst
    end

  end
end
