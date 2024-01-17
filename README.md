# `llm_cli` [![Gem Version](https://badge.fury.io/rb/llm_cli.svg)](https://badge.fury.io/rb/llm_cli)

**WORK IN PROGRESS**

`llm_cli` is a script front-end for large language models that are managed and run by [Ollama](https://ollama.ai/) and OpenAI.

The following command-line program are installed:

* `describe` - describe an image using an Ollama model
* `summarize_ollama` - summarize text using an Ollama model
* `summarize_chatgpt` - summarize text using ChatGPT

This Ruby gem requires Ruby to be installed.
[Here](https://www.mslinn.com/ruby/1000-ruby-setup.html) are some instructions.


## PreRelease Installation

This gem has not been publicly released yet, so you must download the git repo and
type the following before the instructions in the next section will work:

```shell
$ bundle exec rake install
```

If you just want to run the command-line programs,
then skip the next section (Installation) and read the [Usage](#usage) section,
the the [Development](#development) section.


## Installation

### Just the Command-Line Programs

If you just want to run the command-line programs, type:

```shell
$ gem install llm_cli
```


### For Creating A Ruby Application

To make an application that uses this gem, add the follwoing line to your application&rsquo;s `Gemfile`:

```ruby
$ gem 'llm_cli'
```

And then execute:

```shell
$ bundle
```


### For Creating Another Gem

To make a gem that uses this gem as a dependency, add the following to your Gem&rsquo;s `.gemspec`:

```ruby
spec.add_dependency 'llm_cli'
```

And then execute:

```shell
$ bundle
```


## Usage

To see the help information for the commands, do not provide them any parameters:

```shell
$ describe
describe - Use an Ollama model to summarize a document

Syntax: describe OPTIONS FILENAME

OPTIONS:
  -h          Generate this message
  -l LOGLEVEL One of: trace, debug, verbose, info, warning, error, fatal, panic, quiet (default: info)
  -m MODEL    Installed models are listed below
  -t SECONDS  How long to wait for a response from LLM server (default: 60)
  -w WIDTH    Width of output text, in characters (default: console width)
              Set this value to 0 to suppress wrapping.

See: https://mslinn.com/blog/2024/01/14/ollama.html

Installed models are:
Name                     Modified At          Size     Format  Family  Parameter Size  Quantization Level
llama2:70b               2024-01-14 16:53:55  36 GiB   gguf    llama   69B             Q4_0
llama2-uncensored:70b    2024-01-14 17:16:03  36 GiB   gguf    llama   65B             Q4_0
llava:13b                2024-01-15 16:35:25  7.5 GiB  gguf    llama   13B             Q4_0
samantha-mistral:latest  2024-01-14 17:34:17  3.8 GiB  gguf    llama   7B              Q4_0

For example,
to use the llava:13b model,
and wait for the result for up to 10 minutes,
to describe the image in yomama.jpg,
type:

describe -m llava:13b -t 600 yomama.jpg
```

```shell
$ summarize_ollama
```

```shell
$ summarize_chatgpt
```


## Development

After checking out this git repository, install dependencies by typing:

```shell
$ bin/setup
```

You should do the above before running Visual Studio Code.

You can run and debug the code under test instead of the most recently installed version
by setting an environment variable called `VO_DEBUGGING` to any truthy value.
For example,
you could generate the help message from the contents of the `exe/` and `lib/` directories like this:

```shell
VO_DEBUGGING=true ruby exe/describe
```


### Run the Tests

```shell
$ bundle exec rake test
```


### Interactive Session

The following will allow you to experiment:

```shell
$ bin/console
```


### Local Installation

To install this gem onto your local machine, type:

```shell
$ bundle exec rake install
```


### To Release A New Version

To create a git tag for the new version, push git commits and tags,
and push the new version of the gem to https://rubygems.org, type:

```shell
$ bundle exec rake release
```


## Contributing

Bug reports and pull requests are welcome at https://github.com/mslinn/llm_cli.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
