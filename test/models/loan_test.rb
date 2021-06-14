require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "is not loanable" do
    
    mistero_elfi = create(:mistero_elfi)
    loan = create(:filippo, book_id: mistero_elfi.id)
    date_of_loan = mistero_elfi.loans.unloanable(Date.new(2021, 06, 14), Date.new(2021, 06, 11))

    assert date_of_loan != nil

  end
end
