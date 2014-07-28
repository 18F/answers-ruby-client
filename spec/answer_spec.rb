require 'spec_helper'
require 'pry'

describe Answers::Answer, :vcr do
  context 'When API keys are not provided' do
    before(:each) { Answers.init }
    
    describe "GET index" do
      let(:answers) { Answers::Answer.all }
      
      it "retrieves a list of Answers" do
        expect(answers).to(be_a(Array))
      end
      
      it "contains objects only of type Answer::Answer" do
        types = answers.map {|a| a.class}.uniq
        expect(types.length).to(eq(1))
        expect(types.first).to(eq(Answers::Answer))
      end
    end
    
    describe "GET show" do
      let(:answer) { Answers::Answer.find(1) }
      
      it "retrieves a single object of type Answers::Answer" do
        expect(answer).to(be_a(Answers::Answer))
      end
    end
    
    describe "POST create" do
      it "throws an Answers::Error" do
        answer = Answers::Answer.new
        answer.text = 'sample'
        answer.in_language = 'english'
        
        expect { answer.save }.to raise_error(Answers::Error)
      end
    end
    
    describe "PUT update" do
      it "throws an Answers::Error" do
        answer = Answers::Answer.find(1)
        answer.text = 'revised'
        
        expect { answer.save }.to raise_error(Answers::Error)
      end
    end
    
    describe "DELETE destroy" do
      it "throws an Answers::Error" do
        answer = Answers::Answer.find(1)
        
        expect { answer.delete }.to raise_error(Answers::Error)
      end
    end

  end
  
  context 'When API keys are provided' do
    before(:each) do
      Answers.init({
        user_email: ENV['ANSWERS_USER_EMAIL'],
        user_token: ENV['ANSWERS_USER_TOKEN']
      })
    end
    
    describe "POST create" do
      it "creates an Answer::Answer" do
        answer = Answers::Answer.new
        answer.text = 'sample'
        answer.in_language = 'english'
        
        old_created_at = answer.created_at
        old_id = answer.id
        
        answer.save
        
        new_id = answer.id
        new_created_at = answer.created_at
        
        expect(old_id).to(be(nil))
        expect(old_created_at).to(be(nil))
        expect(new_id).to(be_a(Fixnum))
        expect(new_created_at).to(be_a(String))
      end
    end
    
    describe "PUT update" do
      it "updates an Answer::Answer" do
        answer = Answers::Answer.find(1)

        old_updated_at = answer.updated_at
        answer.text = 'new_text'
        answer.save
        
        #expect(answer.updated_at).not_to(eq(old_updated_at))
      end
    end
    
    describe "DELETE destroy" do
      it "deletes an Answer::Answer" do
        answer = Answers::Answer.new
        answer.text = 'sample'
        answer.in_language = 'english'
        answer.save
        
        answer_to_delete = Answers::Answer.find(answer.id)
        answer_to_delete.delete
        query = Answers::Answer.find(answer.id)
        
        expect(query).to(be(nil))
      end
    end
  end
end
