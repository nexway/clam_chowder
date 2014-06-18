# clam_chower

[![Build Status](https://travis-ci.org/nexway/clam_chowder.svg?branch=master)](https://travis-ci.org/nexway/clam_chowder) [![Code Climate](https://codeclimate.com/github/nexway/clam_chowder.png)](https://codeclimate.com/github/nexway/clam_chowder)

Nicely application-level wrapper for anti-virus software.
now supports on clamd only.

## Installing
Put this line in your Gemfile:
```
gem 'clam_chowder'
```

then bundle:
```
% bundle
```

## Usage
```ruby
response = ClamChowder::Scanner.new.scan_io(file_stream)
```

### Infected?
When the file was infected with a virus, that return true and non-it return false.

```ruby
response.infected?
# => true
```

### Virus Name
```ruby
response.virus_name
# => 'Eicar-Test-Signature'
```

### Status
When the file was infected with a virus, that return 'OK' and non-it return 'FOUND'.

```ruby
response.status
# => 'OK'
```

### Stub Mode
clam_chowder prepares a stub mode.  
in stub mode consider infected a virus with written as virus in file.

#### How to use
```ruby
ClamChowder.default_backend = :stub
```

if you use stub-mode when with the production environment on rails.
```ruby
# config/initializers/clam_chowder.rb
ClamChowder.default_backend = Rails.env.production? ? :clamd : :stub
```

## Supported versions
- Ruby 2.0
- Ruby 2.1

## Dependencies
- clamd >= 1.0.1

## Tested environments
- MacOSX Mountain Lion
- Ubuntu 12.04 LTS

## License
clam_chowder is available under the [MIT LICENSE](https://github.com/nexway/clam_chowder/blob/develop/LICENSE.txt)
