require 'rails_helper'

RSpec.describe Offspring, type: :model do
  describe "validating attribute first_name " do
    it "should be required" do
      blank = Factory.build(:offspring, first_name: "")
      blank.should_not be_valid
      blank.errors.generate_message(:first_name, :blank)
      blank.name = "Foo"
      blank.should be_valid
    end

    it "should be longer than 1 character" do
      too_short = Factory.build(:offspring, first_name: 'a')
      too_short.should_not be_valid
      too_short.errors[:first_name].should include("is too short (minimum is 2 characters)")
      too_short.name = 'aa'
      too_short.should be_valid
    end

    it "should be shorter than 101 characters" do
      too_long = Factory.build(:offspring, first_name: 'a' * 101)
      too_long.should_not be_valid
      too_long.errors[:first_name].should include("is too long (maximum is 100 characters)")
      too_long.name = 'a' * 100
      too_long.should be_valid
    end
  end
  describe "validating attribute last_name " do
    it "should be required" do
      blank = Factory.build(:offspring, last_name: "")
      blank.should_not be_valid
      blank.errors.generate_message(:last_name, :blank)
      blank.name = "Foo"
      blank.should be_valid
    end

    it "should be longer than 1 character" do
      too_short = Factory.build(:offspring, last_name: 'a')
      too_short.should_not be_valid
      too_short.errors[:last_name].should include("is too short (minimum is 2 characters)")
      too_short.name = 'aa'
      too_short.should be_valid
    end

    it "should be shorter than 101 characters" do
      too_long = Factory.build(:offspring, last_name: 'a' * 101)
      too_long.should_not be_valid
      too_long.errors[:last_name].should include("is too long (maximum is 100 characters)")
      too_long.name = 'a' * 100
      too_long.should be_valid
    end
  end
  pending("should identify its parent class")
  pending("should not exist without parent")
  pending("subclass must be able to identify with is parent class")
  pending("subclass must be able to identify its class")
  pending("always has a parent associated to it")
  pending("deletes all child classes when parent class destroyed")
  pending("has config in yaml for the type of kids they have")
  pending("has all attributes validated")
  pending("courses are defined with an enum")
  pending("has a max and min age definde in config yaml file")
end
