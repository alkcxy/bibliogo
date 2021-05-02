json.extract! book, :id, :title, :authors, :year, :genre, :language, :spot, :isbn, :abstract, :code, :catalogue, :created_at, :updated_at
json.url book_url(book, format: :json)
json.loans book.loans.where({ date: { '$lte' => loan_date }, expected_return: { '$gte' => quarantine_date }})