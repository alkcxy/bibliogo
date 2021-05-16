module BooksHelper
    def params_for_cloning(book)
        {
            book: {
                title: book.title,
                year: book.year,
                genre: book.genre,
                language: book.language,
                spot: book.spot,
                abstract: book.abstract,
                catalogue: book.catalogue
            },
            authors: book.authors
        }
    end
end
