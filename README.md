# `llm_cli` [![Gem Version](https://badge.fury.io/rb/llm_cli.svg)](https://badge.fury.io/rb/llm_cli)

LlmCli is a script front-end for large language models that are managed and run by [Ollama](https://ollama.ai/) and OpenAI.

The following command-line program are installed:

* `describe` - describe an image using an Ollama model
* `summarize_ollama` - summarize text using an Ollama model
* `summarize_chatgpt` - summarize text using ChatGPT

The above command-line programs use default values and do not support options yet.
The API is more flexible, and allows you to specify the model, temperature, timeout.
For the Ollama commands, you can also specify the URL (address) of the Ollama server.

This Ruby gem requires Ruby to be installed.
[Here](https://www.mslinn.com/ruby/1000-ruby-setup.html) are some instructions.


## PreRelease Installation

This gem has not been publicly released yet, so you must download the git repo and
type the following before the instructions in the next section will work:

```shell
$ bundle exec rake install
```


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
  -h Generate this message
  -l LOGLEVEL one of: trace, debug, verbose, info, warning, error, fatal, panic, quiet
  -m MODEL (installed models are listed below)
  -t SECONDS how long to wait for a response from LLM server

See: https://mslinn.com/blog/2024/01/14/ollama.html

Available models are:
NAME                    ID              SIZE    MODIFIED
llama2:70b              e7f6c06ffef4    38 GB   27 hours ago
llama2-uncensored:70b   bdd0ec2f5ec5    38 GB   27 hours ago
llava:13b               e3b7997801dc    8.0 GB  3 hours ago
samantha-mistral:latest f7c8c9be1da0    4.1 GB  26 hours ago

For example,
to describe the image in yomama.jpg,
and use the llava:13b model,
and wait for the result for up to 10 minutes,
type:

describe yomama.jpg -m llava:13b -t 600

You can mix the options and the filename can be provided in any order:

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
VO_DEBUGGING=true ruby exe/describe_ollama -h
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
