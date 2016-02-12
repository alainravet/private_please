# rubocop:disable Style/Semicolon
require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

class FooBar
  class << self
    def public_c_1
      public_c_2
    end

    def public_c_2; end

    def public_c_3
      private_c_1
    end

    private

    def private_c_1; end
  end

  def public_i_1
    public_i_2
  end

  def public_i_2; end

  def public_i_3
    private_i_1
  end

  def public_i_4  # test one-liners
    private_i_1; public_i_2
  end

  def public_i_5  # test one-liners and :c_call/c_return
    puts nil; public_i_2
  end

  def public_i_6  # test one-liners and :b_call/:b_return
    1.times { public_i_2 }
  end

  private

  def private_i_1; end
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::MethodsCallsTracker, '.privatazable_methods' do
  before do
    PrivatePlease.start_tracking
  end

  describe 'a public instance method' do
    example 'that is only called privately is privatazable' do
      FooBar.new.public_i_1

      assert_result_equal(
        FooBar => {
          '#public_i_2' => [__FILE__, 27],
        }
      )
    end

    example 'that is called both privately and publically is NOT privatazable' do
      FooBar.new.public_i_1
      FooBar.new.public_i_2

      assert_result_is_empty
    end
  end

  describe 'a private instance method' do
    example 'that is called privately is NOT privatazable' do
      FooBar.new.public_i_3

      assert_result_is_empty
    end
  end

  describe 'a public class method' do
    example 'that is only called privately is privatazable' do
      FooBar.public_c_1

      assert_result_equal(
        FooBar => {
          '.public_c_2' => [__FILE__, 12],
        }
      )
    end

    example 'that is called both privately and publically is NOT privatazable' do
      FooBar.public_c_1
      FooBar.public_c_2

      assert_result_is_empty
    end
  end

  describe 'a private class method' do
    example 'that is called privately is NOT privatazable' do
      FooBar.public_c_3

      assert_result_is_empty
    end
  end

  example 'a mix of instance and class privatazable methods are detected' do
    FooBar.new.public_i_1
    FooBar.public_c_1

    assert_result_equal(
      FooBar => {
        '#public_i_2' => [__FILE__, 27],
        '.public_c_2' => [__FILE__, 12],
      }
    )
  end

  example 'one-liner after another :call' do
    FooBar.new.public_i_4

    assert_result_equal(
      FooBar => {
        '#public_i_2' => [__FILE__, 27],
      }
    )
  end

  example 'one-liner after a :c_call' do
    FooBar.new.public_i_5

    assert_result_equal(
      FooBar => {
        '#public_i_2' => [__FILE__, 27],
      }
    )
  end

  example 'one-liner after a :b_call(in a block)' do
    FooBar.new.public_i_6

    assert_result_equal(
      FooBar => {
        '#public_i_2' => [__FILE__, 27],
      }
    )
  end
end
