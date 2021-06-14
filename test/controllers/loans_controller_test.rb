require 'test_helper'

class LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:book_with_loans)
    @loan = @book.loans.first
    @setting = create(:setting)
  end

  teardown do
    Loan.all.each do |loan|
      loan.destroy
    end
    Book.all.each do |book| 
      book.destroy
    end

    @setting.destroy
  end

  test "should get index" do
    get loans_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_url
    assert_response :success
  end

  test "should create loan" do
    loan = build(:riccardo)
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { book_id: @book.id, date: loan.date, expected_return: loan.expected_return, place: loan.place, reader: loan.reader } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should create a new loan before the expected date but after actual date of previous loan" do
    loan = build(:virginia)
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { book_id: @book.id, date: loan.date, expected_return: loan.expected_return, place: loan.place, reader: loan.reader } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should create a new loan after actual date of previous loan even if expected date was before the actual" do
    assert_difference('Loan.count') do
      virginia = create(:virginia, actual_return: "2021-07-14 06:17:10")
    end
    loan = build(:serena)
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { book_id: @book.id, date: loan.date, expected_return: loan.expected_return, place: loan.place, reader: loan.reader } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should create a new loan after actual date of previous loan even if expected date is in the future" do
    mistero_elfi = create(:mistero_elfi)
    loan = build(:filippo)
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { book_id: mistero_elfi.id, date: loan.date, expected_return: loan.expected_return, place: loan.place, reader: loan.reader } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should not create loan when date is not gte return date + quarantine period" do
    loan = build(:francesco)
    assert_difference('Loan.count', 0) do
      post loans_url, params: { loan: { book_id: @book.id, date: loan.date, expected_return: loan.expected_return, place: loan.place, reader: loan.reader } }
    end

    assert_response :success
  end

  test "should show loan" do
    get loan_url(@loan)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_url(@loan)
    assert_response :success
  end

  test "should update loan" do
    patch loan_url(@loan), params: { loan: { actual_return: "2021-05-26 06:17:10", date: @loan.date, expected_return: @loan.expected_return, place: @loan.place, reader: @loan.reader } }
    assert_redirected_to loan_url(@loan)
  end

  test "should destroy loan" do
    assert_difference('Loan.count', -1) do
      delete loan_url(@loan)
    end

    assert_redirected_to loans_url
  end
end
