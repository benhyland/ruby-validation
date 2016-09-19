# A Validation is a type which represents two possible kinds of values.
# A Validation instance is either a single successful value, or a non-empty list of error values.
# It is never anything else; it must be one or the other.
# Neither kind of Validation can contain nil.
#
# Validation comes with some methods for manipulating and composing its values.
# It also comes with factory methods.
class Validation

  # This constructor tries to discourage the user of Validation from hacking around the constraints introduced by the api.
  # Depending on your encoding of success and failure, you might make this private: `private_class_method :new`.
  # For the exercise, you don't need to modify this constructor, but you can if you like.
  def initialize
    raise "You can't instantiate Validation directly, use `success()` or `failure()` instead. Please don't modify or extend Validation yourself."
  end

  #
  # factory methods
  #

  # Create a Validation instance representing a successful value.
  def self.success(value)
    Success.new(value)
  end

  # Create a Validation instance representing at least one error value.
  def self.failure(error, *other_errors)
    Failure.new(NonEmptyList.new(error, *other_errors))
  end

  class Success < Validation
    def initialize(value)
      if value == nil
        raise "Success cannot contain nil"
      end
      @value = value
    end

    def fold(if_failure, if_success)
      if_success.call(@value)
    end

    def is_success?
      true
    end
  end

  class Failure < Validation
    def initialize(errors)
      @errors = errors
    end

    def fold(if_failure, if_success)
      if_failure.call(@errors.to_a)
    end

    def is_success?
      false
    end
  end

  #
  # instance api methods
  #

  # Return true if this Validation represents success, false otherwise.
  def is_success?
    raise "not implemented"
  end

  # Return true if this Validation represents failure, false otherwise.
  def is_failure?
    !is_success?
  end

  # Return the success value if this Validation represents success, or call the given function to provide a default otherwise.
  def get_or_else(lazy_default_value)
    is_success? ? @value : lazy_default_value.call
  end

  # Return this Validation if it represents success, or call the given function to provide a default Validation otherwise.
  def or_else(lazy_default_validation)
    is_success? ? self : lazy_default_validation.call
  end

  # Fold is a function used to transform data structures.
  # It's quite an abstract concept, found in many different languages.
  # Folds can be implemented for lots of different data structures.
  #
  # In general, a fold on some algebraic data type takes functions which mirror the various ways the type can be created.
  # In the case of Validation, there are two options, success() and failure().
  # A fold produces a value which is in some way the result of combining the contents of the data structure.
  # In the case of Validation, there is no recursive structure to the data type, so there is nothing to combine - we just transform the value we find.
  #
  # You might be most familiar with folds in the shape of inject() on Ruby's Enumerable.
  #
  # Further reading:
  # https://wiki.haskell.org/Fold
  # https://en.wikipedia.org/wiki/Algebraic_data_type
  # https://ruby-doc.org/core-2.3.3/Enumerable.html#method-i-inject
  #
  # Our fold() takes two functions, and runs exactly one of them.
  # If this Validation represents failure, it runs the if_failure function, passing the error values as an array.
  # If this Validation represents success, it runs the if_success function, passing the success value.
  # In either case, fold() returns the result of the function called.
  def fold(if_failure, if_success)
    raise "not implemented"
  end

  # If this Validation represents success, apply the given block to the success value and return a successful Validation containing the resulting value.
  #
  # Otherwise, return this Validation.
  def map(&if_success)
    fold(lambda { |errors| self }, lambda { |value| Validation.success(if_success.call(value)) })
  end

  # If this Validation represents success, apply the given block to the success value and return the resulting value, which should be a Validation.
  #
  # Otherwise, return this Validation.
  def flat_map(&if_success)
    fold(lambda { |errors| self }, lambda { |value| if_success.call(value) })
  end

  # If this Validation and the given applicable_validation both represent success, apply the function contained by
  # the applicable_validation to the success value of this instance and return a successful Validation containing the resulting value.
  #
  # Otherwise, return a failure Validation containing all errors from this Validation and from the given applicable_validation.
  def apply(applicable_validation)
    fold(
      lambda { |self_errors| applicable_validation.fold(
        lambda { |other_errors| errs = self_errors + other_errors; Validation.failure(errs[0], *errs[1..-1]) },
        lambda { |if_success| self }
      )},
      lambda { |value| applicable_validation.fold(
        lambda { |errors| applicable_validation },
        lambda { |if_success| Validation.success(if_success.call(value)) }
      )}
    )
  end

  # If the given NonEmptyList of Validations all represent success, then return a single successful Validation containing
  # an array of all the success values, in order.
  #
  # Otherwise, return a single failure Validation containing all the available error values.
  def self.sequence(validations_nel)
    errors = []
    values = []
    validations_nel.each do |validation|
      validation.fold(
        lambda { |es| errors = errors + es },
        lambda { |v| values << v },
      )
    end

    if errors.empty?
      Validation.success(values)
    else
      Validation.failure(errors[0], *errors[1..-1])
    end
  end

  # If the given NonEmptyList of Validations all represent success, then return a single successful Validation containing
  # an array of the results of applying the given block to all the success values, in order.
  #
  # Otherwise, return a single failure Validation containing all the available error values.
  def self.traverse(validations_nel, &block)
    Validation.sequence(validations_nel).map { |values| values.collect &block }
  end

  # If the given NonEmptyList of Validations all represent success, then provide all the success values, in order,
  # as arguments to a single invocation of the given block, and return a successful Validation containing the result.
  #
  # Otherwise, return a failure Validation containing all the available error values.
  def self.mapN(validations_nel, &block)
    Validation.sequence(validations_nel).map { |values| block.call(*values) }
  end
end
