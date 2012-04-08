require 'spec_helper'

import Sage

describe SpreadsheetWrangler do
  
  def data_file(name)
    File.dirname(__FILE__) + '/data/' + name + '.csv'
  end

  before :all do
    # setup = YAML::load(File.read(File.dirname(__FILE__) + '/data/setup.yml'))
    # @filenames = setup['filenames']
    # @owners = setup['owners']
    # @clients   = setup['clients']
  end
  
  describe :parsing do
    
    it 'parses CSV files' do
      importer = SpreadsheetWrangler.new
      importer.import(data_file('simple'))
      importer.errors.should == []
      importer.records.map { |r| r.to_hash }.should == [
        {
          :client_id => 1,
          :client_name => 'Client 1', 
          :employer_id => 10, 
          :employer_name => 'Employer 10',
          :campus_id => nil,
          :campus_name => nil,
          :print_logo_filename => nil,
          :web_logo_filename => nil,
          :owner => nil,
        },
        {
          :client_id => 2, 
          :client_name => 'Client 2', 
          :employer_id => 20, 
          :employer_name => 'Employer 20',
          :campus_id => nil,
          :campus_name => nil,
          :print_logo_filename => nil,
          :web_logo_filename => nil,
          :owner => nil,
        },
        {
          :client_id => 3, 
          :client_name => 'Client 3', 
          :employer_id => 30, 
          :employer_name => 'Employer 30',
          :campus_id => nil,
          :campus_name => nil,
          :print_logo_filename => nil,
          :web_logo_filename => nil,
          :owner => nil,
        },
        {
          :client_id => 4, 
          :client_name => 'Client 4', 
          :employer_id => 40, 
          :employer_name => 'Employer 40',
          :campus_id => nil,
          :campus_name => nil,
          :print_logo_filename => nil,
          :web_logo_filename => nil,
          :owner => nil,
        },
      ]
    end
    
    it 'parses CSV files with either Windows or POSIX line endings' do
      importer_crlf = SpreadsheetWrangler.new
      importer_crlf.import(data_file('line-endings-crlf'))
      importer_crlf.errors.should == []
      
      importer_posix = DataImporter.new
      importer_posix.import(data_file('line-endings-posix'))
      importer_posix.errors.should == []
      
      importer_crlf.records.should == importer_posix.records
    end
    
  end
  
  describe :validation do
    
    it 'validates empty file' do
      importer = SpreadsheetWrangler.new
      importer.import(data_file('empty'))
      importer.errors.should == [
        DataImporter::ValidationError::NoRecords.new
      ]
    end
    
    it 'validates file with no data' do
      importer = SpreadsheetWrangler.new
      importer.import(data_file('headers-only'))
      importer.errors.should == [
        DataImporter::ValidationError::NoRecords.new
      ]
    end

  end
  
  describe :correlation do
    
    it 'correlates' do
      pending "Should correlate"
      # importer = SpreadsheetWrangler.new(:clients => @clients, :filenames => @filenames, :owners => @owners)
      # importer.import(data_file('correlate'))
      # importer.errors.should == []
      # importer.correlation.should == ...
    end
    
  end

end