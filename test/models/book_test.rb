require 'test_helper'

class BookTest < ActiveSupport::TestCase
  teardown do
    Book.delete_all
    Sequence.delete_all
  end

  test "the correct usage of sequence" do
    create(:randomized)
    create(:randomized)
    create(:randomized)
    create(:randomized)
    Book.where(code: 1).destroy

    expected_code = Book.max_code.first.code + 1
    next_code = Book.next_code
    assert next_code == expected_code, "it should be " + expected_code.to_s + " but was " + next_code.to_s
  end

  test "the correct usage of sequence with pre-existings" do
    create(:randomized)
    create(:randomized)
    create(:randomized)
    create(:randomized)
    Book.next_code
    Book.next_code
    Book.next_code
    Book.next_code
    Book.next_code

    expected_code = Sequence.max_sequence(Book.name).first.value + 1
    next_code = Book.next_code
    assert next_code == expected_code, "it should be " + expected_code.to_s + " but was " + next_code.to_s
  end

  test "the correct usage of sequence aligned with books" do
    create(:randomized)
    create(:randomized)
    create(:randomized)
    create(:randomized)
    Book.next_code
    Book.next_code
    Book.next_code
    Book.next_code

    expected_code = Sequence.max_sequence(Book.name).first.value + 1
    next_code = Book.next_code
    assert next_code == expected_code, "it should be " + expected_code.to_s + " but was " + next_code.to_s
  end
end
