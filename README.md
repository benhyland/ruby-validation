Ruby Validation exercise
========================

This project contains tests to drive a functional programming exercise.

It's basically the same exercise as the [Java 8 equivalent](https://github.com/benhyland/validation-workshop).
Because it's in Ruby, it shares the arity advantages and type safety disadvantages with this [Groovy version](https://github.com/benhyland/validation-groovy).

## Exercise

You'll need a Ruby development environment, probably based on `rbenv` and `bundler`.
The main code is under `lib`, while tests are under `spec`.

You can run the tests with `bundle exec rspec`.
`.ruby-version` is provided but the actual version you use shouldn't really matter.

Implement the missing pieces of `validation.rb` to make the tests pass.

It is probably best to address the tests in the order they appear in each suite and to take the suites in the following order:

- validation_structure_spec
- validation_transformation_spec
- validation_applicative_spec

Pay close attention to the api comments, especially if you are unsure what you need to do.
The motivation for some of the api may only be apparent in later tasks.

If you prefer to change the suggested api to be more suited to your preferences, please go ahead!
But try to preserve the restrictions defined by the tests, as well as the functionality.

Once the tests are passing (congratulations!) you may wish to consider any of the following questions as a starting point for discussion:

1. We haven't implemented equality for Validation. Would this be a useful or sensible addition? Why?

2. We haven't implemented anything along the lines of `def get()` to return the value held by the Validation. Why not?

3. Some of the api or implementation may not by very idiomatic for Ruby. Can you identify any similarities with functions already in the Ruby standard library? Are there any things you would like to rename?

4. You may have found ways of implementing parts of the api in terms of other parts. What is the minimum api surface necessary to implement the Validation api thus far? Are there any patterns or further abstractions you can see? Could any of this minimal functionality be further generalised? If not, why not?

5. Surely there must some things about the design of what we have so far that could be improved. Can you identify anything? If so, can you change the design, keep the current tests working, and add any additional tests we need?

6. We've implemented and done some basic testing of a powerful but pretty small api. Can you think of any more specialised (but still domain-agnostic) functionality you would like to use that can be derived from what we've seen so far?

7. We've implemented some varargs functions which can handle any argument arity. If you are familiar with a language which provides a compile-time type system, would it be capable of implementing this functionality in a type-safe way?
