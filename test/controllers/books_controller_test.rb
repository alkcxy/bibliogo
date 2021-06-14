require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:enciclopedia)
  end

  teardown do
    Book.all.each do |book|
      book.destroy
    end
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    bambina = build(:bambina)
    assert_difference('Book.count') do
      post books_url, params: { authors: bambina.authors.join(", "), book: { genre: bambina.genre, language: bambina.language, spot: bambina.spot, title: bambina.title, year: bambina.year, code: bambina.code, isbn: bambina.isbn } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_url(@book)
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book), params: { authors: "Virginia", book: { genre: @book.genre, language: @book.language, spot: @book.spot, title: @book.title, year: @book.year } }
    assert_redirected_to book_url(@book)
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end
end
