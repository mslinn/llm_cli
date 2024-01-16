require 'facets/string/titlecase'
require 'humanize'

class OllamaDriver
  PREFIX = %w[TiB GiB MiB KiB B].freeze

  def self.as_size(integer)
    float = integer.to_f
    i = PREFIX.length - 1
    while float > 512 && i.positive?
      i -= 1
      float /= 1024
    end
    number = float > 9 || float.modulo(1) < 0.1 ? '%d' : '%.1f'
    (number % float) + ' ' + PREFIX[i]
  end

  # the margin_width is the spaces between columns (use at least 1)
  def self.format_table(table, margin_width = 2)
    column_widths = []
    table.each do |row|
      row.each.with_index do |cell, column_num|
        column_widths[column_num] = [column_widths[column_num] || 0, cell.to_s.size].max
      end
    end

    table.collect do |row|
      row.collect.with_index do |cell, column_num|
        cell.to_s.ljust(column_widths[column_num] + margin_width)
      end.join
    end
  end

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
      #{list.yellow}

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

  def self.list
    models = obtain_models
    field_names = %w[name modified_at size]
    digest_names = %w[format family parameter_size quantization_level]
    column_values = []
    field_names.each do |field_name|
      column_values << models.map do |model|
        value = model[field_name]
        field_name == 'size' ? as_size(value) : value
      end
    end
    digest_names.each do |digest_name|
      column_values << models.map { |model| model['details'][digest_name] }
    end
    column_values = column_values.transpose
    headings = (field_names + digest_names).map { |x| x.tr '_', ' ' }.map(&:titlecase)
    column_values = [headings] + column_values
    format_table(column_values).join("\n")
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

  def self.obtain_models
    client = Ollama.new(credentials: { address: @address })
    client.tags.first['models']
  end

  # @return length of widest instance of field_name in the array of hashes
  def self.widest(hash_array, field_name)
    lengths = hash_array.map { |row| row[field_name] }
    lengths.max
  end
end
