# -*- encoding: utf-8 -*-

$LOAD_PATH << 'lib'

require 'sage/spreadsheet-wrangler/version'

Gem::Specification.new do |s|
  s.name          = 'sage-spreadsheet-wrangler'
  s.version       = Sage::SpreadsheetWrangler::VERSION
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.summary       = 'Imports spreadsheets, and provides a validation and correlation infrastructure.'
  s.description   = %q{
    Sage::SpreadsheetWrangler imports spreadsheets, and provides a validation and correlation infrastructure.
  }
  s.homepage      = 'https://github.com/hathersagegroup/sage-spreadsheet-wrangler'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.0'
end