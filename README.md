# fluent-plugin-filter-jq

Filter Plugin to create a new record containing the values converted by [jq](http://stedolan.github.io/jq/).

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-filter-jq.svg)](http://badge.fury.io/rb/fluent-plugin-filter-jq)
[![Build Status](https://travis-ci.org/winebarrel/fluent-plugin-filter-jq.svg?branch=master)](https://travis-ci.org/winebarrel/fluent-plugin-filter-jq)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-filter-jq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-filter-jq

## Configuration

```apache
<filter>
  type record_map
  # see http://stedolan.github.io/jq/manual/
  jq '{foo: .bar}'
  # no_hash_root_key .
</filter>
```

## Usage

```sh
$ cat fluent.conf
<source>
  @type forward
  @id forward_input
</source>

<filter>
  type jq

  # swap value
  jq '{foo:.zoo,zoo:.foo}'
</filter>

<match **>
  @type stdout
  @id stdout_output
</match>

$ fluentd -c fluent.conf
```

```sh
$ echo '{"foo":"bar", "zoo":"baz"}' | fluent-cat test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"zoo":"bar","foo":"baz"}
```
