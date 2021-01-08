json.extract! book, :id, :title, :authors, :year, :genre, :language, :spot, :isbn, :abstract, :code, :created_at, :updated_at
json.url book_url(book, format: :json)
