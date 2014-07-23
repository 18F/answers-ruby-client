# answers-ruby-client

Low level Ruby access to the [Answers Platform](https://github.com/18F/answers) API

## Installation

TBD

## Usage

### The Vision

(not quite there yet)

```ruby
require 'answers'

Answers.init

questions = Answers::Question.all
questions.each do |question|
  p question.id
  p question.text
end

answers = Answers::Answer.all
answers.each do |answer|
  p answer.id
  p answer.text
  p answer.question_id
  q = Answers::Question.find(question.id)
  p q.text
end

# write API (requires authentication)

Answers.init({
  user_email: 'person@email.tld',
  user_token: '1234567890qwertyuiop'
})

question = Answers::Question.new
question.text = 'Is this a question?'
question.save

answer = Answers::Answer.new
answer.text = 'Yes, this is a question.'
answer.question_id = question.id
answer.save

```

#### TODO

1. Test coverage
2. Serializing JSON responses
3. Documentation

## Contributing

1. Fork it ( https://github.com/18F/answers-ruby-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# License

Public Domain. See LICENSE.txt.
