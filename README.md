# Rubocop::DirMethods

This gem is a tool designed to extend the functionality of RuboCop. It provides single RuboCop/Cop with capability to define and enforce custom naming conventions for public methods within specific directories in your Ruby projects. With this gem, you can maintain consistent coding practices and preserve the integrity of your project's codebase.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-dir_methods', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rubocop-dir_methods

## Usage

Imagine you have a Rails application with a classic `controllers` directory:
```
- sample_rails_app
    - app
        - controllers
            - application_controller.rb
            - sample_controller.rb
        ...    
    ...        
```
And you wish to enforce RESTful method naming conventions to help developers think in terms of REST. You can configure your project to allow only RESTful method names within the `controllers` directory:
```
# .rubocop.yml
require:
  - rubocop-dir_methods

Naming/DirMethods:
  dirs:
    app/controllers:
      allowed_methods:
        - new
        - create
        - show
        - edit
        - update
        - destroy
      reason: "We want to follow RESTful design in controllers"

```

If a developer creates a method that does not adhere to these conventions, the linter will promptly notify them, ensuring compliance with the established guidelines before the code review process:
```ruby
# app/controllers/sample_controller.rb
class SampleController < ApplicationController
  def sample_public_method
    sample_implementation
  end
end 
```
After running `rubocop`:
```sh
rubocop
...
app/controllers/sample_controller.rb:3:3: C: Naming/DirMethods: Invalid public method name: sample_public_method (reason: We want to follow RESTful design in controllers)
  def sample_public_method ...
  ^^^^^^^^^^^^^^^^^^^^^^^^
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GeorgeGorbanev/rubocop-dir_methods.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
