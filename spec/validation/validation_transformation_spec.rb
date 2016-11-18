require 'nel/non_empty_list'
require 'validation/validation'
require_relative 'matchers/matchers'

RSpec.describe Validation do
  it "should transform success value with fold" do
    validation = Validation.success("yay")
    transformed = validation.fold(lambda { fail "shouldn't need to call this" }, lambda { |s| s.length })

    expect(transformed).to be 3
  end

  it "should transform failure value with fold" do
    validation = Validation.failure("boo", "oh noes")
    transformed = validation.fold(lambda { |errors| errors.length }, lambda { fail "shouldn't need to call this" })

    expect(transformed).to be 2
  end

  it "should transform success with map" do
    validation = Validation.success("yay")
    transformed = validation.map { |s| s.length }

    expect(transformed).to be_success_of(3)
  end

  it "should not transform failure with map" do
    validation = Validation.failure("boo")
    transformed = validation.map { fail "shouldn't need to call this" }

    expect(transformed).to be_failure_of("boo")
  end

  it "should transform success with flat_map" do
    validation = Validation.success("yay")
    transformed_to_success = validation.flat_map { |s| Validation.success(s.length) }
    transformed_to_failure = validation.flat_map { |s| Validation.failure("boo") }

    expect(transformed_to_success).to be_success_of(3)
    expect(transformed_to_failure).to be_failure_of("boo")
  end

  it "should not transform failure with flat_map" do
    validation = Validation.failure("boo")
    not_transformed = validation.flat_map { fail "shouldn't need to call this" }

    expect(not_transformed).to be_failure_of("boo")
  end
end
