module Sage

  class SpreadsheetWrangler
  
    #
    # Data record
    #
  
    class Record
      
      def self.create_class(fields)
        @@fields = fields
        
        record_class = Class.new(self) do
          
          @@canonical_field_names = Hash[
            @@fields.keys.map { |n| [n.to_s.delete('_'), n] }
          ]
          
          @@fields.each do |name, type|
            
            define_method(name) do
              raise "Unknown field: #{name.inspect}" unless @@fields[name]
              @data[name]
            end

            define_method("#{name}=") do |value|
              raise "Unknown field: #{name.inspect}" unless @@fields[name]
              value = value.to_s.strip.gsub(/\s+/, ' ')
              value = case value.downcase
              when '', /^[[:punct:]]+$/, 'z:none'
                nil
              else
                case type
                when :integer
                  case value
                  when /^\d+$/
                    value.to_i
                  else
                    # raise "Invalid integer value: #{value.inspect}"
                    value
                  end
                when :bool
                  case value.downcase
                  when 'true', 'yes', '1'
                    true
                  when 'false', 'no', '0'
                    false
                  else
                    # raise "Invalid boolean value: #{value.inspect}"
                    value
                  end
                when nil, :string
                  value
                else
                  raise "Unknown type: #{type.inspect} for field #{name.inspect}"
                end
              end
              @data[name] = value
            end
            
          end
        end
      end
      
      # Convert a field name to a symbol if it's one of the field names we handle. Use the canonical field name.
      # Example: 'client_id' will be used for any of the following: 'client_id', 'client id', 'clientid', 'Cl%iEn tId'

      def self.canonicalize_field_name(name)
        n = name.to_s.downcase.gsub(/[^a-z]/, '')
        f = @@canonical_field_names[n]
        if f
          f.to_sym
        else
          nil
        end
      end
      
      attr_accessor :row
                
      def initialize(row, data={})
        @row = row
        @data = Hash[
          @@fields.map { |key, value| [key, nil] }
        ]
        data.each { |key, value| method("#{key}=").call(value) if key }
      end
          
      def to_hash
        @data
      end
      
      def ==(other)
        self.to_hash == other.to_hash
      end
      
      def hash
        @data.hash
      end
    
    end

  end
  
end