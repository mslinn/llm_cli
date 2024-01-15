# `Llm_util` [![Gem Version](https://badge.fury.io/rb/llm_util.svg)](https://badge.fury.io/rb/llm_util)

LlmUtil is a script front-end for large language models that are managed and run by [Ollama](https://ollama.ai/) and OpenAI.

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
$ gem install llm_util
```


### For Creating A Ruby Application

To make an application that uses this gem, add the follwoing line to your application&rsquo;s `Gemfile`:

```ruby
$ gem 'llm_util'
```

And then execute:

```shell
$ bundle
```


### For Creating Another Gem

To make a gem that uses this gem as a dependency, add the following to your Gem&rsquo;s `.gemspec`:

```ruby
spec.add_dependency 'llm_util'
```

And then execute:

```shell
$ bundle
```


## Usage

To see the help information, type:

```shell
$ describe
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

Bug reports and pull requests are welcome at https://github.com/mslinn/llm_util.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
