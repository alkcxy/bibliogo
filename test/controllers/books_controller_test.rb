require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = create(:enciclopedia)
    @user = create(:user)
    post login_url, params: { email: @user.email, password: @user.password }
  end

  teardown do
    Loan.all.each do |loan|
      loan.destroy
    end
    
    Book.all.each do |book|
      book.destroy
    end

    User.all.each do |user|
      user.destroy
    end

    Sequence.delete_all
  end

  test "should get index" do
    Loan.delete_all
    Book.delete_all
    one = create(:randomized) do |book|
      create_list(:not_returned, 1, book: book)
    end
    two = create(:randomized) do |book|
      create_list(:in_loan, 1, book: book)
    end
    three = create(:randomized) do |book|
      create_list(:in_quarantine, 1, book: book)
    end
    four = create(:randomized) do |book|
      create_list(:lendable, 1, book: book)
    end
    get books_url
    assert_response :success
    assert_select "tr:nth-child(1) td:nth-child(11) a", "Ancora da restituire"
    assert_select "tr:nth-child(2) td:nth-child(11) a", "In prestito"
    assert_select "tr:nth-child(3) td:nth-child(11) a", "In quarantena"
    assert_select "tr:nth-child(4) td:nth-child(11) a", "Disponibile" do
      assert_select ":match('href', ?)", new_loan_path
    end

  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "Code of a new Book should be the max + 1 of previously created ones" do
    Loan.delete_all
    Book.delete_all
    create(:randomized)
    create(:randomized)
    create(:randomized)
    create(:randomized)
    Book.where(code: 1).destroy
    expected_code = Book.max_code.first.code + 1
    
    bambina = build(:bambina)
    assert_difference('Book.count') do
      post books_url, params: { authors: bambina.authors.join(", "), book: { genre: bambina.genre, language: bambina.language, spot: bambina.spot, title: bambina.title, year: bambina.year, isbn: bambina.isbn } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should create book" do
    bambina = build(:bambina)
    assert_difference('Book.count') do
      post books_url, params: { authors: bambina.authors.join(", "), book: { genre: bambina.genre, language: bambina.language, spot: bambina.spot, title: bambina.title, year: bambina.year, isbn: bambina.isbn } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "auth users should show book without any loans with the proper loan button" do
    get book_url(@book)
    assert_response :success
    assert_select "#unloanable-alert", false
    assert_select "#new-loan"
  end

  test "auth users should show book returned as lendable with the proper loan button" do
    @book = create(:bambina)
    create(:lendable, book: @book)
    get book_url(@book)
    assert_response :success
    assert_select "#unloanable-alert", false
    assert_select "#new-loan"
  end

  test "should show book not returned as still lent" do
    @book = create(:bambina)
    create(:not_returned, book: @book)
    get book_url(@book)
    assert_response :success
    assert_select "#unloanable-alert" do
      assert_select "a", "Ancora da restituire"
    end
  end

  test "should show book not yet returned" do
    @book = create(:bambina)
    create(:in_loan, book: @book)
    get book_url(@book)
    assert_response :success
    assert_select "#unloanable-alert" do
      assert_select "a", "In prestito"
    end
  end

  test "should show book returned and in quarantine" do
    @book = create(:bambina)
    create(:in_quarantine, book: @book)
    get book_url(@book)
    assert_response :success
    assert_select "#unloanable-alert" do
      assert_select "a", "In quarantena"
    end
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
