wit-ruby
========

[![Gem Version](https://badge.fury.io/rb/wit-ruby.png)](http://badge.fury.io/rb/wit-ruby)

Easy interface for interacting with the [Wit.ai](http://wit.ai) natural language parsing API.

This project will expand as the Wit.ai API expands, but as it stands there's a single endpoint. You can hit this
endpoint easily with `Wit.message([your message])`, which uses Wit.ai to convert that phrase or sentence into an object
with an intent, and entities if any are available.

You will need to create a Wit.ai account and begin training it.

## Installation

```ruby
gem 'wit-ruby', '>= 0.0.3'
```

You'll need to set an environment variable named `WIT_TOKEN` or specify your token with `Wit.token = [your token]`.

You can also optionall specify a version by setting the `WIT_VERSION` environment variable or by using `Wit.version = [your version]`.

```shell
export WIT_TOKEN=[your token]
```


## Usage

```ruby
result = Wit.message('Hi')
result.outcomes # an array of possible outcomes. if Wit.AI is unable to determine an intent this will be an empty `[]`.
outcome = result.outcomes[0] # Grab the first outcome... may not be the most likely?
outcome.intent # will be Hello with the default Wit instance.
outcome.confidence # will be relatively low initially.
outcome.entities # will be {}, but if there are entities this would be an array of them.
```

### Result properties/methods

We use hashie to provide easy access to the JSON response from Wit.AI. Please see the [Wit.AI documention](https://wit.ai/docs/http/20141022#get-intent-via-text-link) for details on the result structure.


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Mode Set](https://github.com/modeset)


## Make Code Not War
![crest](https://secure.gravatar.com/avatar/aa8ea677b07f626479fd280049b0e19f?s=75)
