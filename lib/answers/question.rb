module Answers
  class Question
  
    QUESTION_ATTRS = [
      {name: :id, read_only: true},
      {name: :created_at, read_only: true},
      {name: :updated_at, read_only: true},
      {name: :text, read_only: false},
      {name: :in_language, read_only: false},
      {name: :answers, read_only: false}
    ]
  
    QUESTION_ATTRS.each do |attribute|
      attr_fn = attribute[:read_only] ? :attr_reader : :attr_accessor
      send(attr_fn, attribute[:name])
    end
  
    def initialize(params={})
      QUESTION_ATTRS.each do |attribute|
        instance_variable_set("@#{attribute[:name]}", params[attribute[:name]]) if params[attribute[:name]]
      end
      update_attributes!(params)
    end
  
    def attributes
      ivar_to_sym = Proc.new {|ivar| ivar.to_s.sub(/^@/, '').to_sym}
      
      attributes = instance_variables.inject({}) do |r, s|
        r.merge!({ivar_to_sym[s] => instance_variable_get(s)})
      end.delete_if do |k,v|
        !QUESTION_ATTRS.map {|attribute| attribute[:name]}.include?(ivar_to_sym[k])
      end 
      
      attributes
    end
  
    def new?
      @id.nil?
    end

    def self.find(id)
      response = Answers.client.get(Protocol.question_uri(id))
      
      if response.has_key?('status')
        if response['status']
          return nil
        end
      end
      
      question_hash = response['questions'].first
      question = new(question_hash)
          
      question
    end
    
    def self.all
      response = Answers.client.get(Protocol.question_uri)
      questions = response['questions']
      
      questions.map {|q| new(q)}
    end
      
    def save
      body   = attributes.delete_if {|k,v| v.nil?} 
      path   = new? ? Protocol.question_uri : Protocol.question_uri(@id)
      method = new? ? :post : :put
    
      response = Answers.client.send(method, path, body)
      question_hash = response['questions'].first

      update_attributes!(question_hash)
    
      self
    end
  
    def delete
      raise "Cannot delete unsaved object." if new?
      response = Answers.client.delete(Protocol.question_uri(@id))
    
      response
    end
  
    private
  
      def update_attributes!(attributes)
        attributes.each_pair do |key, value|
          update_attribute!(key.to_sym, value)
        end
      end
  
      def update_attribute!(attribute_name, attribute_value)
        instance_variable_set("@#{attribute_name}", attribute_value)
      end
  end
end
