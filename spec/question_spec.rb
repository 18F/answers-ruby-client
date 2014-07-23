require 'spec_helper'
require 'pry'

describe Answers::Question do
  context 'When no API keys are provided' do
    before(:each) { Answers.init }
    
    describe "GET index" do
      let(:questions) { Answers::Question.all }
      
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
        #binding.pry
        
        #expect { question.delete }.to raise_error(Answers::Error)
      end
    end

  end
end