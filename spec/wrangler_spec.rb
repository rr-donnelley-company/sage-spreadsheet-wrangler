require 'spec_helper'

include Sage

class MyWrangler < SpreadsheetWrangler
  
  def initialize
    super(
      :client_id => :integer,
      :client_name => :string,
      :employer_id => :integer,
      :employer_name => :string,
      :campus_id => :ineger,
      :campus_name => :string,
      :print_logo_filename => :string,
      :web_logo_filename => :string,
      :owner => :string,
    )
  end
  
end

describe MyWrangler do
  
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
      wrangler = MyWrangler.new
      wrangler.import(data_file('simple'))
      wrangler.errors.should == []
      wrangler.records.map { |r| r.to_hash }.should == [
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
      wrangler_crlf = MyWrangler.new
      wrangler_crlf.import(data_file('line-endings-crlf'))
      wrangler_crlf.errors.should == []
      
      wrangler_posix = MyWrangler.new
      wrangler_posix.import(data_file('line-endings-posix'))
      wrangler_posix.errors.should == []
      
      wrangler_crlf.records.should == wrangler_posix.records
    end
    
  end
  
  describe :validation do
    
    it 'validates empty file' do
      wrangler = MyWrangler.new
      wrangler.import(data_file('empty'))
      wrangler.errors.should == [
        MyWrangler::ValidationError.new(:no_records)
      ]
    end
    
    it 'validates file with no data' do
      wrangler = MyWrangler.new
      wrangler.import(data_file('headers-only'))
      wrangler.errors.should == [
        MyWrangler::ValidationError.new(:no_records)
      ]
    end

  end
  
  describe :correlation do
    
    it 'correlates' do
      pending "Should correlate"
      # wrangler = MyWrangler.new(:clients => @clients, :filenames => @filenames, :owners => @owners)
      # wrangler.import(data_file('correlate'))
      # wrangler.errors.should == []
      # wrangler.correlation.should == ...
    end
    
  end

end