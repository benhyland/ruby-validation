require 'nel/non_empty_list'
require 'validation/validation'

RSpec.describe Validation do
  it "should hint to the user that it shouldn't be extended" do
    expect { Validation.new }.to raise_error "You can't instantiate Validation directly, use `success()` or `failure()` instead. Please don't modify or extend Validation yourself."
  end

  it "should provide a class method to create success values" do
    validation = Validation.success("yay")

    expect(validation.is_success?).to be true
    expect(validation.is_failure?).to be false
  end

  it "should provide a class method to create failure values" do
    validation = Validation.failure("boo")

    expect(validation.is_success?).to be false
    expect(validation.is_failure?).to be true

    validation = Validation.failure("boo", "oh noes")

    expect(validation.is_success?).to be false
    expect(validation.is_failure?).to be true
  end

  it "should fail when factory methods are called with invalid parameters" do
    expect { Validation.success }.to raise_error ArgumentError
    expect { Validation.success(nil) }.to raise_error RuntimeError
    expect { Validation.success("a", "b") }.to raise_error ArgumentError

    expect { Validation.failure }.to raise_error ArgumentError
    expect { Validation.failure(nil) }.to raise_error RuntimeError
    expect { Validation.failure("a", nil, "b") }.to raise_error RuntimeError
  end

  it "should retrieve success value from success" do
    value = "yay"
    validation = Validation.success(value)
    retrieved_value = validation.get_or_else(lambda { fail "shouldn't need to call this" })
    expect(retrieved_value).to be value
  end

  it "should retrieve default value from failure" do
    default_value = "foo"
    validation = Validation.failure("boo")
    retrieved_value = validation.get_or_else(lambda { default_value })
    expect(retrieved_value).to be default_value
  end

  it "should retrieve self from success validation" do
    validation = Validation.success("yay")
    retrieved_validation = validation.or_else(lambda { fail "shouldn't need to call this" })
    expect(retrieved_validation).to be validation
  end

  it "should retrieve default validation from failure validation" do
    default_validation = Validation.success("foo")
    validation = Validation.failure("boo")
    retrieved_validation = validation.or_else(lambda { default_validation })
    expect(retrieved_validation).to be default_validation
  end
end
