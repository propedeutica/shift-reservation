require 'rails_helper'

RSpec.describe Offspring, type: :model do
  it "should create a new instance given valid attributes" do
    FactoryGirl.create(:offspring)
  end

  it "should initialize successfully as an instance of the described class" do
    expect(subject).to be_a_kind_of described_class
  end

  it "should identify its parent class" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "should not exist without parent" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "subclass must be able to identify with is parent class" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "subclass must be able to identify its class" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "always has a parent associated to it" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "deletes all child classes when parent class destroyed" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "has config in yaml for the type of kids they have" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "has all attributes validated" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "courses are defined with an enum" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  it "has a max and min age definde in config yaml file" do
    pending("something else getting finished")
    this_should_not_get_executed
  end
end
describe "validating attribute first_name " do
  it "should be required" do
    blank = Factory.build(:offspring, first_name: "")
    blank.should_not be_valid
    blank.errors[:first_name].should include("can't be blank")

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
    blank.errors[:last_name].should include("can't be blank")

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
