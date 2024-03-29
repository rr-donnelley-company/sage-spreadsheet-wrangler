require 'sage/spreadsheet-wrangler/version'
require 'sage/spreadsheet-wrangler/record'
require 'sage/spreadsheet-wrangler/validation_error'

require 'csv'

module Sage
  
  class SpreadsheetWrangler
    
    attr_accessor :record_class
    attr_accessor :file
    attr_accessor :records
    attr_accessor :errors
    attr_accessor :correlation
    attr_accessor :unmapped_headers
    
    def initialize(fields)
      @record_class = Record.create_class(fields)
      @correlation = {}
      @unmapped_headers = []
    end
    
    def import(file)
      @file = file
      data = @file.respond_to?(:read) ? @file.read : File.read(@file)
      csv = CSV.parse(data,
        :headers => true,
        :header_converters => proc { |n|
          field = @record_class.canonicalize_field_name(n)
          @unmapped_headers << n if field.nil?
          field
        },
      )
      @records = []
      csv.each_with_index do |row, i|
        hash = row.to_hash
        # remove unknown fields
        hash.delete_if { |key, value| key.nil? }
        record = @record_class.new(i + 2, hash)
        # skip empty rows
        @records << record unless record.empty?
      end
      validate
      correlate if respond_to?(:correlate) && valid?
    end
  
    # Whether or not imported records are valid (eg, no errors).
  
    def valid?
      @errors && @errors.empty?
    end
    
    private
  
    # Validates current data against validation methods
  
    def validate
      @errors = []
      methods.grep(/^validate_/).each { |m| method(m).call }
      @errors.each { |e| e.file = @file }
      valid?
    end
    
    def correlate
      @correlation
    end
    
    # Helper to make little validation DSL.
    
    def self.validate(name, &block)
      define_method("validate_#{name}") do
        instance_exec(&block)
      end
    end
    
    # Helper to make little validation DSL.
    
    def invalidate(*args)
      error = SpreadsheetWrangler::ValidationError.new(*args)
      @errors << error
    end
    
  end
  
end

require 'sage/spreadsheet-wrangler/validations/has_records'
require 'sage/spreadsheet-wrangler/validations/no_duplicate_records'