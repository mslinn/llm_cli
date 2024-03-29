require 'optparse'

class OllamaDriver
  LOGLEVEL = %w[trace debug verbose info warning error fatal panic quiet].freeze

  def self.help(msg = nil)
    puts "#{msg}\n".red if msg
    progname = File.basename $PROGRAM_NAME
    msg = <<~END_MSG
      #{"#{progname} - Use an Ollama model to summarize a document".green}

      Syntax: #{progname} OPTIONS FILENAME

      OPTIONS:
        -h          Generate this message
        -l LOGLEVEL One of: #{LOGLEVEL.join ', '} (default: info)
        -m MODEL    Installed models are listed below
        -t SECONDS  How long to wait for a response from LLM server (default: 60)
        -w WIDTH    Width of output text, in characters (default: console width)
                    Set this value to 0 to suppress wrapping.

      See: https://mslinn.com/blog/2024/01/14/ollama.html

      #{'Installed models are:'.green}
      #{list.yellow}

      For example,
      to use the llava:13b model,
      and wait for the result for up to 10 minutes,
      to describe the image in yomama.jpg,
      type:

      describe -m llava:13b -t 600 yomama.jpg

      If you do not specify a model, the list of llava models is computed, then the middle one is automatically chosen.
    END_MSG
    puts msg
    exit 1
  end

  def self.parse_options
    default_model = find_llava
    options = { timeout: 60, loglevel: 'info', width: IO.console.winsize.last }
    OptionParser.new do |parser|
      parser.program_name = File.basename __FILE__

      parser.on('-l', '--loglevel LOGLEVEL', Integer, "Logging level, one of #{LOGLEVEL.join ', '}. (#{options[:loglevel]})")
      parser.on('-m', '--model MODEL',       String,  "Ollama model to use (#{options[:model]})")
      parser.on('-t', '--timeout TIMEOUT',   Integer, "Seconds to wait for response (#{options[:timeout]})")
      parser.on('-w', '--width WIDTH',       Integer, "Width of output text, in characters #{options[:width]}")

      parser.on_tail('-h', '--help', 'Show this message') do
        help
      end
    end.order!(into: options)
    unless options[:model]
      options[:model] = default_model
      puts "No model was specified, so #{default_model} was selected."
    end
    if options[:loglevel] && !options[:loglevel] in LOGLEVEL
      help "Error: Invalid loglevel value (#{options[:loglevel]}), must be one of one of: #{LOGLEVEL.join ', '}."
    end
    help "Error: Specified model (#{options[:model]}) does not exist." unless model_exist? options[:model]
    options
  end
end
