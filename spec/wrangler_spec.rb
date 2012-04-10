require 'spec_helper'

include Sage

class MyWrangler < SpreadsheetWrangler
  
  def initialize
    super(
      :client_id => :integer,
      :client_name => :string,
      :employer_id => :integer,
      :employer_name => :string,
      :owner => { :type => :string, :match => ['owner', /user/] },
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
          :owner => 'Bob',
        },
        {
          :client_id => 2, 
          :client_name => 'Client 2', 
          :employer_id => 20, 
          :employer_name => 'Employer 20',
          :owner => 'Sue',
        },
        {
          :client_id => 3, 
          :client_name => 'Client 3', 
          :employer_id => 30, 
          :employer_name => nil,
          :owner => 'Frank',
        },
        {
          :client_id => 4, 
          :client_name => 'Client 4', 
          :employer_id => nil, 
          :employer_name => nil,
          :owner => 'Jane',
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
    
    it 'parses CSV file from IO object' do
      File.open(data_file('simple')) do |io|
        wrangler = MyWrangler.new
        wrangler.import(io)
        wrangler.errors.should == []
      end
    end
    
    it 'parses CSV file from StringIO object' do
      io = StringIO.new(File.read(data_file('simple')))
      wrangler = MyWrangler.new
      wrangler.import(io)
      wrangler.errors.should == []
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

    it 'validates there are no duplicate records' do
      importer = MyWrangler.new
      importer.import(data_file('no_duplicate_records'))
      importer.errors.should == [
        MyWrangler::ValidationError.new(:duplicate_records, :row => 3),
      ]
    end

  end
  
end