require 'colorator'
require 'json'
require 'net/http'

# Uses the OpenAI GPT-3 API for Ruby to summarize a document.
#
# Adjust the max_tokens and temperature parameters based on your preferences.
# Remember to check the latest OpenAI API documentation for any updates or changes.
# If there's a GPT-4 API available, you would need to adapt the code accordingly.
class ChatGPT
  ENDPOINT = 'https://api.openai.com/v1/engines/davinci-codex/completions'.freeze

  def self.help(msg)
    puts "#{msg}\n".red if msg
    progname = File.basename $PROGRAM_NAME
    msg = <<~END_MSG
      #{progname} - Use the OpenAI GPT-3 API for Ruby to summarize a document
      Usage: #{progname} FILENAME
    END_MSG
    puts msg
    exit 1
  end

  # @param max_tokens controls desired summary length
  # @param temperature control creativity
  def initialize(max_tokens = 150, temperature = 0.8)
    @api_key = ENV['OPEN_API_KEY'] # rubocop:disable Style/FetchEnvVar
    abort 'Error: the OPEN_API_KEY environment variable is not defined.' unless @api_key

    @max_tokens = max_tokens
    @temperature = temperature
  end

  def summarize(filename)
    document = File.read filename

    params = {
      prompt:      document,
      max_tokens:  @max_tokens,
      temperature: @temperature,
    }

    json_params = params.to_json
    uri = URI(ENDPOINT)
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  { 'Content-Type'  => 'application/json',
                                    'Authorization' => "Bearer #{@api_key}" })
    request.body = json_params
    response     = http.request request
    result       = JSON.parse response.body
    if response.code.to_i >= 400
      puts "Error #{response.code} (#{response.message}) from #{ENDPOINT}"
      exit 1
    end
    puts result['choices'][0]['text']
  end
end
