require 'spec_helper'
require 'pry'

describe Answers::Question, :vcr do
  context 'When API keys are not provided' do
    
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    before(:each) { Answers.init }
    
    describe "GET index" do
      let(:questions) do
        Answers::Question.all
      end
      
      it "retrieves a list of Questions" do
        expect(questions).to(be_a(Array))
      end
      
      it "contains objects only of type Answer::Question" do
        types = questions.map {|q| q.class}.uniq
        expect(types.length).to(eq(1))
        expect(types.first).to(eq(Answers::Question))
      end
    end
    
    describe "GET show" do
      let(:question) { Answers::Question.find(1) }
      
      it "retrieves a single object of type Answers::Question" do
        expect(question).to(be_a(Answers::Question))
      end
    end
    
    describe "POST create" do
      it "throws an Answers::Error" do
        question = Answers::Question.new
        question.text = 'sample'
        question.in_language = 'english'
        
        expect { question.save }.to raise_error(Answers::Error)
      end
    end
    
    describe "PUT update" do
      it "throws an Answers::Error" do
        question = Answers::Question.find(1)
        question.text = 'revised'
        
        expect { question.save }.to raise_error(Answers::Error)
      end
    end
    
    describe "DELETE destroy" do
      it "throws an Answers::Error" do
        question = Answers::Question.find(1)
        
        expect { question.delete }.to raise_error(Answers::Error)
      end
    end

  end
  
  context 'When API keys are provided' do
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    
    before(:each) do
      Answers.init({
        user_email: ENV['ANSWERS_USER_EMAIL'],
        user_token: ENV['ANSWERS_USER_TOKEN']
      })
    end
    
    describe "POST create" do
      it "creates an Answer::Question" do
        question = Answers::Question.new
        question.text = 'sample'
        question.in_language = 'english'
        
        old_created_at = question.created_at
        old_id = question.id
        
        question.save
        
        new_id = question.id
        new_created_at = question.created_at
        
        expect(old_id).to(be(nil))
        expect(old_created_at).to(be(nil))
        expect(new_id).to(be_a(Fixnum))
        expect(new_created_at).to(be_a(String))
      end
    end
    
    describe "PUT update" do
      it "updates an Answer::Question" do
        question = Answers::Question.find(1)

        old_updated_at = question.updated_at
        question.text = 'new_text'
        question.save
        
        #expect(question.updated_at).not_to(eq(old_updated_at))

      end
    end
    
    describe "DELETE destroy" do
      it "deletes an Answer::Question" do
        question = Answers::Question.new
        question.text = 'sample'
        question.in_language = 'english'
        question.save
        
        question_to_delete = Answers::Question.find(question.id)
        question_to_delete.delete
        query = Answers::Question.find(question.id)
        
        expect(query).to(be(nil))
      end
    end
  end
end
