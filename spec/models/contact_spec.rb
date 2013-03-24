require 'spec_helper'

FactoryGirl.define do
  factory :contact do
    name 'Michael'
  end
end

describe Contact do
  it {should validate_presence_of :name}
  it {should allow_mass_assignment_of :name}
end