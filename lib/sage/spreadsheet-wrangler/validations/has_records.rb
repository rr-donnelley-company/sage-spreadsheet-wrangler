module Sage
  
  class SpreadsheetWrangler
    
    validate :has_records do
      if @records.empty?
        invalidate(:no_records,
          :message => "No data records were found")
      end
    end
  
  end
  
end