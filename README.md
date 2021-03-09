# spec_file_generator [![spec_file_generator.svg](https://api.travis-ci.org/sinventor/spec_file_generator.svg?branch=master)](https://travis-ci.org/github/sinventor/spec_file_generator)

This is a command line utility to generate spec file template (for rspec engine) based on ruby file which contains class statement. You can run a command and get basic spec file for that class with writing further tests afterwards. Unfortunately this program will not write tests for you :).

## Installation

This gem is a command line program therefore it can be installed using standard command:

    $ gem install spec_file_generator

Once a gem is installed you have the `spec_file_generator` command line program. There is also a `sfg` shorthand added for convenience.

## Usage

Let's assume you have a `lib/foo/bar.rb` file having the following lines:
The basic usage would be running a program specifying the source file (using `-s` or `--source` flag):

    $ spec_file_generator -s lib/foo/bar.rb

If the content of source file contains the following lines:

```ruby
module Foo
  class Bar
  end
end
```

then spec file will be generated at `spec/foo/bar_spec.rb` file with the following content:

```ruby
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Foo::Bar do
end
```

Also you can specify `-p` (`--place-into`) option to change a root spec directory (`spec` by default), for example:

    $ spec_file_generator -s lib/foo/bar.rb -p custom/folder/to/spec

If you are going to call a program not being at current working directory you can pass absolute paths for those flags:

    $ spec_file_generator -s /home/username/apps/myapp/lib/foo/bar.rb -p /home/username/apps/myapp/spec

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinventor/spec_file_generator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
