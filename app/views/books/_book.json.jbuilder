json.extract! book, :id, :title, :authors, :year, :genre, :language, :spot, :isbn, :abstract, :code, :catalogue, :created_at, :updated_at
json.url book_url(book, format: :json)
date_of_loan = book.loans.unloanable(loan_date, quarantine_date)
if date_of_loan
    mex = "In Prestito."
    if date_of_loan <= loan_date
        mex = "In Quarantena."
    end
    json.loan mex + " Non prestabile fino al " + l(loan_from_raw(date_of_loan))
else
    json.loan "Prestabile"
end
