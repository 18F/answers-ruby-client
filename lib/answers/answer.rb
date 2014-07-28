require 'active_support/inflector'

module Answers
  class Answer < BaseModel
  
    ANSWER_ATTRS = [
      {name: :id, read_only: true},
      {name: :created_at, read_only: true},
      {name: :updated_at, read_only: true},
      {name: :text, read_only: false},
      {name: :in_language, read_only: false},
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
      update_attributes!(params)
    end
  
    def attributes
      ivar_to_sym = Proc.new {|ivar| ivar.to_s.sub(/^@/, '').to_sym}
      
      attributes = instance_variables.inject({}) do |r, s|
        r.merge!({ivar_to_sym[s] => instance_variable_get(s)})
      end.delete_if do |k,v|
        !ANSWER_ATTRS.map {|attribute| attribute[:name]}.include?(ivar_to_sym[k])
      end 
      
      attributes
    end

  end
end
