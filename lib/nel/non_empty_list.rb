class NonEmptyList
  # Create a NonEmptyList instance guaranteed to contain at least one element.
  def initialize(first_element, *other_elements)
    if first_element == nil || other_elements == nil || other_elements.include?(nil)
      raise "NonEmptyList may not contain nil"
    end
    @values = [first_element] + other_elements
  end

  # Return the first element.
  def head
    @values[0]
  end

  # Returns an array containing all elements except the first, in order.
  # Returns an empty array if this NonEmptyList contains only a single element.
  def tail
    @values[1..-1]
  end

  # Returns a new NonEmptyList that contains all the elements of this instance, with the given element appended.
  def append(element)
    NonEmptyList.new(head, *(tail << element))
  end

  # Returns a new NonEmptyList that contains all the elements of this instance, with the given element prepended.
  def prepend(element)
    NonEmptyList.new(element, *to_a)
  end

  # Returns a new NonEmptyList that contains all the elements of this instance, with all the given elements appended in the given order.
  def append_all(*elements)
    NonEmptyList.new(head, *(tail + elements))
  end

  # Returns a new NonEmptyList that contains all the elements of this instance, with all the given elements prepended in the given order.
  def prepend_all(*elements)
    new_values = elements + to_a
    NonEmptyList.new(new_values[0], *(new_values[1..-1]))
  end

  # Returns an array containing all the elements of this NonEmptyList in order.
  def to_a
    [head] + tail
  end
end
