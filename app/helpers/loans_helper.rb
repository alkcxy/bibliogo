module LoansHelper

    def book_title loan
        if loan && loan.book
            loan.book.title 
        else
            params[:book_title]
        end
    end

    def loan_status(book_loans)
        loan = book_loans.status(loan_date, quarantine_duration).first if book_loans
        if book_loans.nil? || loan.nil?
            message = "Disponibile"
            css="success"
            returned_date = nil
            status = {
                message: message,
                returned_date: returned_date,
                loan: loan,
                css: css
            }
        else
            if loan.actual_return
                returned_date = loan.actual_return
            else
                returned_date = loan.expected_return
            end

            if !loan.actual_return && loan.expected_return <= loan_date
                message = "Ancora da restituire"
                css = "danger"
            else
                if returned_date <= loan_date
                    message = "In quarantena"
                    css="warning"
                else
                    message = "In prestito"
                    css="info"
                end
            end

            status = {
                message: message,
                returned_date: returned_date,
                loan: loan,
                css: css
            }
        end
        logger.debug status
        status
    end

end
