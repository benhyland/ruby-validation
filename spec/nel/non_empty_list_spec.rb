require 'nel/non_empty_list'

RSpec.describe NonEmptyList do
  it "cannot contain nil" do
    expect { NonEmptyList.new }.to raise_error ArgumentError
    expect { NonEmptyList.new("hello", "world", nil) }.to raise_error RuntimeError
  end

  it "returns initial reference in reasponse to head()" do
    head = "hello"
    expect(NonEmptyList.new(head, "hello", "hello").head).to be(head)
  end

  it "takes a shallow copy of the given tail" do
    head = "hello"
    tail = ["world"]
    nel = NonEmptyList.new(head, *tail)
    tail << "!"
    expect(nel.to_a).to eq(["hello", "world"])
  end

  it "returns a shallow copy in response to to_a()" do
    head = "hello"
    tail = ["world"]
    nel = NonEmptyList.new(head, *tail)
    arr = nel.to_a
    tail << "!"
    expect(arr).to eq(["hello", "world"])
    arr << "!"
    expect(nel.to_a).to eq(["hello", "world"])
  end

  it "returns a shallow copy in response to tail()" do
    head = "hello"
    tail = ["world"]
    nel = NonEmptyList.new(head, *tail)
    new_tail = nel.tail
    tail << "!"
    expect(new_tail).to eq(["world"])
    new_tail << "!"
    expect(nel.tail).to eq(["world"])
  end

  it "returns a new NEL instance in response to prepend()" do
    nel = NonEmptyList.new("hello")
    new_list = nel.prepend("world")
    expect(nel.to_a).to eq(["hello"])
    expect(new_list.to_a).to eq(["world", "hello"])
  end

  it "returns a new NEL instance in response to append()" do
    nel = NonEmptyList.new("hello")
    new_list = nel.append("world")
    expect(nel.to_a).to eq(["hello"])
    expect(new_list.to_a).to eq(["hello", "world"])
  end

  it "returns a new NEL instance in response to prepend_all()" do
    nel1 = NonEmptyList.new("foo", "bar")
    nel2 = NonEmptyList.new("baz", "quux")
    new_list = nel1.prepend_all(*nel2.to_a)
    expect(nel1.to_a).to eq(["foo", "bar"])
    expect(nel2.to_a).to eq(["baz", "quux"])
    expect(new_list.to_a).to eq(["baz", "quux", "foo", "bar"])
  end

  it "returns a new NEL instance in response to append_all()" do
    nel1 = NonEmptyList.new("foo", "bar")
    nel2 = NonEmptyList.new("baz", "quux")
    new_list = nel1.append_all(*nel2.to_a)
    expect(nel1.to_a).to eq(["foo", "bar"])
    expect(nel2.to_a).to eq(["baz", "quux"])
    expect(new_list.to_a).to eq(["foo", "bar", "baz", "quux"])
  end
end
