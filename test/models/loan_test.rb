require 'test_helper'

class LoanTest < ActiveSupport::TestCase
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

  test "is loanable with old loans" do
    book = create(:book_with_loans)
    status = book.loans.status(Date.today, 3.days).first
    assert status.nil?
  end

  test "is loanable without any loans yet" do
    book = create(:bambina)
    status = book.loans.status(Date.today, 3.days).first
    assert status.nil?
  end

  test "is not loanable" do
    @book = create(:bambina)
    create(:in_loan, book: @book)
    status = @book.loans.status(Date.today, 3.days).first
    assert !status.nil?
  end

  test "there isn't any active loan today" do
    book = create(:bambina)
    loan = Loan.active(Date.today, 1.month.since(Date.today)).where(book_id: book.id).first
    assert loan.nil?
  end

  test "there is an active loan today" do
    @book = create(:bambina)
    create(:in_loan, book: @book)
    loan = Loan.active(Date.today, 1.month.since(Date.today)).where(book_id: @book.id).first
    assert !loan.nil?
  end

  test "there is a late loan" do
    @book = create(:bambina)
    @loan = create(:not_returned, book: @book)
    loan = Loan.late(Date.today).first
    assert loan == @loan

    book = Book.late(Date.today).first
    assert book == @book
  end

  test "there isn't any late loans" do
    @book = create(:bambina)
    create(:lendable, book: @book)
    loan = Loan.late(Date.today).first
    assert loan.nil?

    book = Book.late(Date.today).first
    assert book.nil?
  end
end
