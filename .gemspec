
spec = Gem::Specification.new do |s|
  s.name = 'did'
  s.version = '0.2.01'
  s.summary = 'Time tracking for the non-clairvoyant'
  s.description = <<EOT
DID is a time tracking system where you tell it what you did, not what
you plan to do. 
EOT
  s.author = "Andrew Paradise"
  s.email = "adparadise@gmail.com"
  s.homepage = "http://github.com/adparadise/did"
  s.add_dependency('sqlite3')
  s.add_dependency('activerecord', '~>3.0')
  s.executables = ['did', 'did_autocomplete']

  db_files = Dir.glob("db/**/*").reject {|f| f=~/\.sq3$/}
  bin_files = Dir.glob("bin/**/*")
  lib_files = Dir.glob("lib/**/*")
  tests_files = Dir.glob("tests/**/*")
  doc_files = ["README.rdoc"]
  s.files = db_files + lib_files + tests_files + doc_files
  
  s.require_path = 'lib'
end
