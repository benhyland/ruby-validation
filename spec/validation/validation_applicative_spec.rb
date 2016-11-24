require 'nel/non_empty_list'
require 'validation/validation'
require_relative 'matchers/matchers'

RSpec.describe Validation do
  it "should apply function in validation to success validation" do
    value_validation = Validation.success("yay")
    function_validation = Validation.success(lambda { |s| s.length })

    expect(value_validation.apply(function_validation)).to be_success_of(3)
    expect(value_validation.apply(Validation.failure("boo"))).to be_failure_of("boo")
  end

  it "should apply function in validation to failure validation" do
    value_validation = Validation.failure("boo")

    expect(value_validation.apply(Validation.success(lambda { fail "shouldn't need to call this" }))).to be_failure_of("boo")
    expect(value_validation.apply(Validation.failure("oh noes", "not again"))).to be_failure_of("boo", "oh noes", "not again")
  end

  it "should sequence list of success validations" do
    validations = NonEmptyList.new(Validation.success("a"), Validation.success("b"), Validation.success("c"))
    sequenced = Validation.sequence(validations)

    expect(sequenced).to be_success_of(["a", "b", "c"])
  end

  it "should sequence list with failure validations" do
    validations = NonEmptyList.new(Validation.failure("boo"), Validation.success("b"), Validation.failure("oh noes", "not again"))
    sequenced = Validation.sequence(validations)

    expect(sequenced).to be_failure_of("boo", "oh noes", "not again")
  end

  it "should traverse list of success validations" do
    validations = NonEmptyList.new(Validation.success("a"), Validation.success("bb"), Validation.success("ccc"))
    traversed = Validation.traverse(validations) { |s| s.length }

    expect(traversed).to be_success_of([1, 2, 3])
  end

  it "should traverse list with failure validations" do
    validations = NonEmptyList.new(Validation.failure("boo"), Validation.success("b"), Validation.failure("oh noes", "not again"))
    traversed = Validation.traverse(validations) { fail "shouldn't need to call this" }

    expect(traversed).to be_failure_of("boo", "oh noes", "not again")
  end

  it "should transform several successful validations with mapN" do
    validations = NonEmptyList.new(Validation.success("woo"), Validation.success(2), Validation.success("yay"))
    transformed = Validation.mapN(validations) { |a, b, c| "#{a} #{b} #{c}" }

    expect(transformed).to be_success_of("woo 2 yay")
  end

  it "should transform several validations with failures with mapN" do
    validations = NonEmptyList.new(Validation.failure("boo"), Validation.success(2), Validation.failure("oh noes", "not again"), Validation.success("yay"))
    transformed = Validation.mapN(validations) { fail "shouldn't need to call this" }

    expect(transformed).to be_failure_of("boo", "oh noes", "not again")
  end
end
