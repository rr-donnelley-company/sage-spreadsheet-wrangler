require 'sage/spreadsheet-wrangler/version'
require 'sage/spreadsheet-wrangler/record'
require 'sage/spreadsheet-wrangler/validation_error'

require 'csv'

# convenience method to convert Array to Hash, based on provided key

# class Array
# 
#   def to_hash(key)
#     Hash[
#       map { |e|
#         [e[key], e]
#       }
#     ]
#   end
# 
# end

module Sage
  
  class SpreadsheetWrangler
    
    attr_accessor :record_class
    attr_accessor :file
    attr_accessor :records
    attr_accessor :errors
    attr_accessor :correlation
    
    def initialize(fields)
      @record_class = Record.create_class(fields)
    end
    
    def import(file)
      @file = file
      csv = CSV.read(file,
        :headers => true,
        :header_converters => proc { |n| @record_class.canonicalize_field_name(n) },
      )
      @records = []
      csv.each_with_index do |row, i|
        hash = row.to_hash
        hash.delete_if { |key, value| key.nil? }
        # skip empty rows
        unless hash.values.compact.empty?
          record = @record_class.new(i + 2, hash)
          @records << record
        end
      end
      validate
      correlate if valid?
    end
  
    # Whether or not imported records are valid (eg, no errors).
  
    def valid?
      @errors && @errors.empty?
    end
  
    private
  
    # Validates current data against validation methods
  
    def validate
      @errors = []
      @@validations.each { |name, validation| instance_exec(&validation) }
      @errors.each { |e| e.file = @file }
      @errors.empty?
    end
    
    # Helper to make little validation DSL.
    
    def self.validate(name, &block)
      @@validations ||= {}
      @@validations[name] = block
    end
    
    # Helper to make little validation DSL.
    
    def invalid(*args)
      @errors << SpreadsheetWrangler::ValidationError.new(*args)
    end
    
    def correlate
      @correlation = Hash.new([])
      #FIXME
      @correlation
    end
    
  end
  
end

require 'sage/spreadsheet-wrangler/validations/has_records'
require 'sage/spreadsheet-wrangler/validations/no_duplicate_records'