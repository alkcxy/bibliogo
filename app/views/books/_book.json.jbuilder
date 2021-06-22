json.extract! book, :id, :title, :year, :genre, :language, :spot, :isbn, :abstract, :code, :catalogue, :created_at, :updated_at
json.authors book.authors.join(', ')
json.url book_url(book, format: :json)
status = loan_status(book.loans)
if status[:loan]
    json.loan status[:message] + ". Non prestabile fino al " + l(loan_from_raw(status[:returned_date]))
else
    json.loan status[:message]
end
