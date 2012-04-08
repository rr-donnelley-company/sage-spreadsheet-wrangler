module Sage

  class SpreadsheetWrangler

    #
    # Specific validation error
    #
  
    class ValidationError
    
      attr_accessor :type
      attr_accessor :message
      attr_accessor :details
      attr_accessor :row
      attr_accessor :key
      attr_accessor :value
      attr_accessor :file
    
      def initialize(type, params={})
        @type = type
        params.each { |name, value| method("#{name}=").call(value) }
      end
    
      def description
        s = @message
        s += ": #{@details}" if @details
        if row
          s += " (at row #{@row.inspect}" if @row
          if @key
            s += ", with key #{@key.inspect}"
            if @value
              s += " having value #{@value.inspect}"
            end
          end
          s += ')'
        end
        s
      end
  
      # Note that this method does *not* compare the message or details, but only the type, row, key, and value.
      # This is mostly to assist in testing, so we can create a bunch of expected errors and see if
      # we've received them, without having to duplicate the particular (human-readable) message.

      def ==(other)
        self.type == other.type && self.row == other.row && self.key == other.key && self.value == other.value
      end
    
      def to_hash
        {
          :type => type,
          :message => message,
          :details => details,
          :row => row,
          :key => key,
          :value => value
        }
      end

    end

  end
  
end