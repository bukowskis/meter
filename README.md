# Meter

A generic abstraction layer for tracking metrics and other data via configurable backends.

# Installation

```bash
gem install meter
````

# Usage

#### Configuration

```ruby
Meter.configure do |config|
  config.namespace = 'my_app'
  config.backends << Meter::Backends::Datadog.new
  config.backends << Meter::Backends::JsonLog.new
end
```

#### Syntax

```ruby
Meter.increment key, sample_rate: 0.5, tags: {}, data: {}
````

#### Examples

```ruby
Meter.increment 'my.key'
Meter.increment 'my.key', 5
Meter.increment 'my.key', 5, sample_rate: 0.25

Meter.gauge 'my.gauge.key', 20
```
