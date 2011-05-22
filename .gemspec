
spec = Gem::Specification.new do |s|
  s.name = 'did'
  s.version = '0.2'
  s.summary = 'Time tracking for the non-clairvoyant'
  s.description = <<EOT
DID is a time tracking system where you tell it what you did, not what
you plan to do. 
EOT
  s.author = "Andrew Paradise"
  s.email = "adparadise@gmail.com"
  s.homepage = "http://github.com/homnom"
  s.add_dependency('sqlite3')
  s.add_dependency('activerecord')
  s.executables = ['did', 'did_autocomplete']
end
