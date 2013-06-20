# Meter

BETA!

A generic abstraction layer for fire and forgetting measurements via UDP.

# Installation

```bash
gem install meter
````

# Usage

#### Syntax

```ruby
Meter.increment key, delta, options
````

#### Examples 

```ruby
Meter.increment 'my.key'
Meter.increment 'my.key', 5
Meter.increment 'my.key', 5, sample_rate: 0.25

Meter.gauge 'my.gauge.key', 20
```
