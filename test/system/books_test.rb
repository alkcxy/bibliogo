require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = create(:book)
  end

  teardown do
    Book.delete_all
    Loan.delete_all
    User.delete_all
  end

  test "visiting the index" do
    visit books_url

    assert_selector "h1", text: "Libri"
    assert_text @book.title
  end

  test "creating a Book" do
    visit books_url
    click_on "Nuovo Libro"

    fill_in "Titolo", with: "Il nome della rosa"
    fill_in "authors", with: "Eco, Umberto"
    fill_in "Anno", with: "1980"
    fill_in "Genere", with: "Romanzo"
    fill_in "Lingua", with: "ita"
    fill_in "Posto", with: "Scaffale A1"
    fill_in "Isbn", with: "9788804669112"
    find("input[type=submit]").click

    assert_text "Book was successfully created."
    assert_text "Il nome della rosa"
  end

  test "updating a Book" do
    user = create(:user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "t34$ttestereS"
    click_on "Login"

    visit books_url
    find("a[title='Modifica']", match: :first).click
    fill_in "Titolo", with: "Titolo aggiornato"
    find("input[type=submit]").click

    assert_text "Book was successfully updated."
  end

  test "destroying a Book" do
    visit books_url
    page.accept_confirm do
      find("a[title='Cancella']", match: :first).click
    end

    assert_text "Book was successfully destroyed."
  end
end
