require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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

    Setting.all.each do |setting|
      setting.destroy
    end

  end

  test "is not loanable" do
    
    book = create(:book_with_loans)
    status = book.loans.status(Date.today, 3.days).first
    assert status.nil?

  end

  test "there isn't any active loan today" do
    book = create(:book_with_loans)
    loan = Loan.active(Date.today, 1.month.since(Date.today)).where(book_id: book.id).first
    assert loan.nil?
  end
end
