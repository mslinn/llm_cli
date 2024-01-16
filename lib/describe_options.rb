require 'optparse'

class OllamaDriver
  VERBOSITY = %w[trace debug verbose info warning error fatal panic quiet].freeze

  def self.parse_options
    options = { model: 'llava', timeout: 5 * 60, loglevel: 'warning', verbose: false }
    OptionParser.new do |parser|
      parser.program_name = File.basename __FILE__
      @parser = parser

      parser.on('-l', '--loglevel LOGLEVEL', Integer, "Logging level (#{VERBOSITY.join ', '})")
      parser.on('-m', '--model MODEL', 'Overwrite output file if present')
      parser.on('-t', '--timeout TIMEOUT', Integer, "Seconds to wait for response (1..#{options[:timeout]})")

      parser.on_tail('-h', '--help', 'Show this message') do
        help
      end
    end.order!(into: options)
    help "Invalid verbosity value (#{options[:verbose]}), must be one of one of: #{VERBOSITY.join ', '}." if options[:verbose] && !options[:verbose] in VERBOSITY
    if options[:shake].negative? || options[:shake] > 10
      help "Specified model (#{options[:model]}) does not exist.\n" +
           "Available models are:\n".green +
           `ollama list`.chomp
    end
    options
  end
end
