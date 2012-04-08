# -*- encoding: utf-8 -*-

$LOAD_PATH << 'lib'

require 'sage/spreadsheet-importer/version'

Gem::Specification.new do |s|
  s.name          = 'sage-spreadsheet-importer'
  s.version       = Sage::SpreadsheetImporter::VERSION
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.summary       = 'Imports spreadsheets, and provides a validation and correlation infrastructure.'
  s.description   = %q{
    Sage::SpreadsheetImporter imports spreadsheets, and provides a validation and correlation infrastructure.
  }
  # s.homepage      = 'http://github.com/FIXME'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  # s.add_dependency 'builder'
end