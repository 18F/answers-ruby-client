module Answers
  class BaseModel
    
    def new?
      @id.nil?
    end
    
    def self.resource_name
      to_s.demodulize.downcase.to_sym
    end
    
    def resource_name
      self.class.resource_name
    end
    
    def self.hash_key
      self.resource_name.to_s.pluralize
    end
    
    def hash_key
      self.class.hash_key
    end
    
    def self.find(id)
      response = Answers.client.get(Protocol.uri(resource_name, id))
      
      if response.has_key?('status')
        if response['status']
          return nil
        end
      end
      
      item_hash = response[hash_key].first
      item = new(item_hash)
          
      item
    end
    
    def self.all
      response = Answers.client.get(Protocol.uri(resource_name))
      items = response[hash_key]
      
      items.map {|i| new(i)}
    end
    
    def save
      body   = attributes.delete_if {|k,v| v.nil?} 
      path   = new? ? Protocol.uri(resource_name) : Protocol.uri(resource_name, @id)
      method = new? ? :post : :put
    
      response = Answers.client.send(method, path, body)
      item_hash = response[hash_key].first

      update_attributes!(item_hash)
    
      self
    end
  
    def delete
      raise Answers::Error.new("Cannot delete unsaved object.") if new?
      response = Answers.client.delete(Protocol.uri(resource_name, @id))
    
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