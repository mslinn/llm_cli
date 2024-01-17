require_relative 'llm_cli/version'

# Require all Ruby files in 'lib/', except this file
Dir[File.join(__dir__, '*.rb')].each do |file|
  require file unless file.end_with?('/llm_cli.rb')
end

Dir[File.join(__dir__ + '/ollama', '*.rb')].each do |file|
  puts "requiring #{file}"
  require file unless file.end_with?('/llm_cli.rb')
end
