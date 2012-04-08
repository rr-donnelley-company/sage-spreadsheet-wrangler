module Sage
  
  class SpreadsheetWrangler
    
    validate :has_records do
      if @records.empty?
        invalid(:no_records,
          :message => "No data records were found")
      end
    end
  
  end
  
end