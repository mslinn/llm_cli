require 'base64'
require 'colorator'
require 'json'
require 'net/http'
require 'ollama-ai'

class OllamaDriver # rubocop:disable Metrics/ClassLength
  def self.help(msg = nil)
    puts "#{msg}\n".red if msg
    progname = File.basename $PROGRAM_NAME
    msg = <<~END_MSG
      #{"#{progname} - Use an Ollama model to summarize a document".green}

      Syntax: #{progname} OPTIONS FILENAME

      OPTIONS:
        -h Generate this message
        -l LOGLEVEL one of: #{VERBOSITY.join ', '}
        -m MODEL (installed models are listed below)
        -t SECONDS how long to wait for a response from LLM server

      See: https://mslinn.com/blog/2024/01/14/ollama.html

      #{'Installed models are:'.green}
      #{`ollama list`.chomp}

      For example,
      to describe the image in yomama.jpg,
      and use the llava:13b model,
      and wait for the result for up to 10 minutes,
      type:

      describe yomama.jpg -m llava:13b -t 600

      You can mix the options and the filename can be provided in any order:

      describe -m llava:13b -t 600 yomama.jpg
    END_MSG
    puts msg
    exit 1
  end

  # [{ 'name' => 'llama2:latest',
  # 'modified_at' => '2024-01-06T15:06:23.6349195-03:00',
  # 'size' => 3_826_793_677,
  # 'digest' =>
  # '78e26419b4469263f75331927a00a0284ef6544c1975b826b15abdaef17bb962',
  # 'details' =>
  # { 'format' => 'gguf',
  #   'family' => 'llama',
  #   'families' => ['llama'],
  #   'parameter_size' => '7B',
  #   'quantization_level' => 'Q4_0' } }
  # ]
  def self.model_exist?(model_name)
    client = Ollama.new(credentials: { address: @address })
    client.tags.find do |model|
      return true if model['name'] == model_name
    end
    false
  end

  # @return length of widest instance of field_name in the array of hashes
  def self.widest(hash_array, field_name)
    lengths = hash_array.map { |row| row[field_name] }
    lengths.max
  end

  def self.list
    result = ''
    client = Ollama.new(credentials: { address: @address })
    client.tags.map do |tags|
      field_names = %w[name modified_at size]
      widths = field_names.map { |name| widest(tags['models'], name) }
      field_names.zip(widths).each do |field_name, width|
        result += ljust(row[field_name], width)
      end
      result += "\n"
    end
    result
  end

  # @param temperature control creativity
  def initialize(
    address:     'http://localhost:11434',
    model:       'samantha-mistral',
    temperature: 0.8,
    timeout:     60
  )
    @address = address
    @model = model
    @temperature = temperature
    @timeout = timeout
  end

  # You need to choose a model that supports images, like LLaVA or bakllava
  # ollama pull llava:13b
  def describe_image(image_filename)
    @client = Ollama.new(
      credentials: { address: @address },
      options:     {
        server_sent_events: true,
        temperature:        @temperature,
        connection:         { request: { timeout: @timeout, read_timeout: @timeout } },
      }
    )
    result = @client.generate(
      {
        model:  @model,
        prompt: 'Please describe this image.',
        images: [Base64.strict_encode64(File.read(image_filename))],
      }
    )
    puts result.map { |x| x['response'] }.join
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
