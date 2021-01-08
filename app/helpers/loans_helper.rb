module LoansHelper

    def book_title loan
        loan.book.title if loan && loan.book
    end

end
