module Answers
  module Protocol
    DOMAIN      = 'http://localhost:1337'
    API_PATH    = '/api'
    API_VERSION = 'v1'
    BASE_PATH   = "#{DOMAIN}#{API_PATH}/#{API_VERSION}"
    
    EMAIL_HEADER_KEY = 'X-User-Email'
    TOKEN_HEADER_KEY = 'X-User-Token'
    
    DEFAULT_CONTENT_TYPE = 'application/json'

    def self.question_uri(question_id=nil)
      if question_id
        "#{BASE_PATH}/questions/#{question_id}"
      else
        "#{BASE_PATH}/questions"  
      end
    end
    

    def self.answer_uri(answer_id=nil)
      if answer_id
        "#{BASE_PATH}/answers/#{answer_id}"
      else
        "#{BASE_PATH}/answers"
      end
    end
    
    def self.uri(resource, id=nil)
      case resource
      when :question
        question_uri(id)
      when :answer
        answer_uri(id)
      end
    end

  end
end
