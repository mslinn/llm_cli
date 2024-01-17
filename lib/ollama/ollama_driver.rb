require 'base64'
require 'colorator'
require 'io/console'
require 'json'
require 'net/http'
require 'ollama-ai'

class OllamaDriver
  # @param temperature control creativity
  def initialize(
    address:     'http://localhost:11434',
    loglevel:    'info',
    model:       'samantha-mistral',
    temperature: 0.8,
    timeout:     60,
    width:       IO.console.winsize.last
  )
    @address = address
    @loglevel = loglevel
    @model = model
    @temperature = temperature
    @timeout = timeout
    @width = width
  end

  # You need to choose a model that supports images, like LLaVA or bakllava
  # ollama pull llava:13b
  def describe_image(image_ref)
    @client = Ollama.new(
      credentials: { address: @address },
      options:     {
        server_sent_events: true,
        temperature:        @temperature,
        connection:         { request: { timeout: @timeout, read_timeout: @timeout } },
      }
    )
    image_contents = if image_ref.start_with? 'http'
                       Net::HTTP.get(URI.parse(image_ref))
                     else
                       File.read(image_ref)
                     end
    result = @client.generate(
      {
        model:  @model,
        prompt: 'Please describe this image.',
        images: [Base64.strict_encode64(image_contents)],
      }
    )
    text = result.map { |x| x['response'] }.join.strip
    puts @width.positive? ? OllamaDriver.wrap(text, @width) : text
  rescue Ollama::Errors::RequestError => e
    puts e.request.wrapped_exception.class.name.red
  end

  def summarize(filename)
    @client = Ollama.new(
      credentials: { address: @address },
      options:     {
        server_sent_events: false,
        temperature:        @temperature,
        connection:         { request: { timeout: @timeout, read_timeout: @timeout } },
      }
    )
    result = @client.generate(
      {
        model:  @model,
        prompt: query(File.read(filename)),
        stream: false,
      }
    )
    puts result.first['response']
  end

  def query(text)
    <<~END_MSG
      Write a summary of the following text delimited by triple backticks.
      Return your response which covers the key points of the text.
      ```#{text}```
      SUMMARY:
    END_MSG
  end
end
