module Sage
  
  class SpreadsheetWrangler
  
    validate :no_duplicate_records do
      dups = {}
      @records.each do |record|
        if (previous = dups[record.hash])
          invalid(:duplicate_records, 
            :message => "There may be no duplicate records", 
            :details => "Record with same values found at row #{previous.row}",
            :row => record.row)
        else
          dups[record.hash] = record
        end
      end
    end
    
  end
  
end