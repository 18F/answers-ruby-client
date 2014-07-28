[![Build Status](https://travis-ci.org/18F/answers-ruby-client.svg?branch=master)](https://travis-ci.org/18F/answers-ruby-client) [![Code Climate](https://codeclimate.com/github/18F/answers-ruby-client.png)](https://codeclimate.com/github/18F/answers-ruby-client) [![Coverage Status](https://coveralls.io/repos/18F/answers-ruby-client/badge.png)](https://coveralls.io/r/18F/answers-ruby-client)

# answers-ruby-client

Low level Ruby access to the [Answers Platform](https://github.com/18F/answers) API

## Installation

```ruby
gem 'answers-ruby-client'
```

```sh
gem install answers-ruby-client
```

## Usage

### Synopsis

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

### CRUD

#### Create

```ruby
Answers::Question.new(text: 'hello').save
Answers::Answer.new(text: 'hello').save
```

#### Read

```ruby
Answers.Question.find(1)
Answers.Answer.find(1)
```

#### Update

```ruby
a = Answers::Question.find(1)
a.text = 'new_text'
a.save
```

#### Delete

```ruby
a = Answers::Question.find(1)
a.text = 'new_text'
a.delete
```

### Question attributes

- `id` (`Integer`)
- `created_at` (`String`)
- `updated_at` (`String`)
- `text` (`String`) - the text of the question
- `in_language` (`String`) - the language of the question
- `need_to_know` (`String`)


### Answer

- `id` (`Integer`)
- `created_at` (`String`)
- `updated_at` (`String`)
- `text` (`String`) - the text of the answer
- `in_language` (`String`) - the language of the answer
- `question_id` (`Integer`) - the id of the question that the Answer belongs to

## Contributing

1. Fork it ( https://github.com/18F/answers-ruby-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# License

Public Domain. See LICENSE.txt.
