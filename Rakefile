require 'tasks/standalone_migrations'		
MigratorTasks.new {|t|}

task :default do

end

task :environment do
  $: << 'lib'
  require 'env'
end
