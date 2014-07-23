module Answers
  class Answer
  
    ANSWER_ATTRS = [
      {name: :id, read_only: true},
      {name: :created_at, read_only: true},
      {name: :updated_at, read_only: true},
      {name: :text, read_only: false},
      {name: :in_language, read_only: false},
      {name: :need_to_know, read_only: false},
      {name: :question_id, read_only: false}
    ]
  
    ANSWER_ATTRS.each do |attribute|
      attr_fn = attribute[:read_only] ? :attr_reader : :attr_accessor
      send(attr_fn, attribute[:name])
    end
  
    def initialize(params={})
      ANSWER_ATTRS.each do |attribute|
        instance_variable_set("@#{attribute[:name]}", params[attribute[:name]]) if params[attribute[:name]]
      end
    end
  
    def attribute_names
      ANSWER_ATTRS.map {|attribute| attribute[:name]}
    end
  
    def attributes
      hash = {}
      attribute_names.each do |attr_name|
        hash.merge!({
          attr_name.to_sym => instance_variable_get("@#{attr_name}")
        })
      end
    
      hash
    end
  
    def new?
      @id.nil?
    end

    def self.find(id)
      response = Answers.client.get(Protocol.answer_uri(id))
      answer_hash = response['answers'].first
      answer = new(answer_hash)
    
      answer
    end
      
    def save
      body   = attributes.delete_if {|k,v| v.nil?} 
      path   = new? ? Protocol.answer_uri : Protocol.answer_uri(@id)
      method = new? ? :post : :put
    
      response = Answers.client.send(method, path, body)
      answer_hash = response['answers'].first

      update_attributes!(answer_hash)
    
      self
    end
  
    def delete
      raise "Cannot delete unsaved object." if new?
      response = Answers.client.delete(Protocol.answer_uri(@id))
    
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