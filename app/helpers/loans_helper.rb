module LoansHelper

    def book_title loan
        if loan && loan.book
            loan.book.title 
        else
            params[:book_title]
        end
    end

end
