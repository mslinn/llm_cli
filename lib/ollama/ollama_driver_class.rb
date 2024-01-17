require 'date'
require 'facets/string/titlecase'
require 'humanize'
require_relative '../util/text_util'

class OllamaDriver
  extend TextUtil

  def self.list
    models = obtain_models
    field_names = %w[name modified_at size]
    digest_names = %w[format family parameter_size quantization_level]
    column_values = []
    field_names.each do |field_name|
      column_values << models.map do |model|
        value = model[field_name]
        case field_name
        when 'modified_at'
          dt = DateTime.parse value
          dt.strftime '%F %T'
        when 'size'
          as_size(value)
        else
          value
        end
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

  def self.model_names
    obtain_models.map { |model| model['name'] }
  end

  # @return middle of array of model names that start with 'llava:'
  def self.find_llava
    llavas = model_names.select { |name| name.start_with?('llava:') }
    llavas[llavas.length / 2]
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
    client.tags.first['models'].find do |model|
      return true if model['name'] == model_name
    end
    false
  end

  def self.obtain_models
    client = Ollama.new(credentials: { address: @address })
    client.tags.first['models']
  end
end
