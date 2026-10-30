require "application_system_test_case"

class LoansTest < ApplicationSystemTestCase
  setup do
    @book = create(:book)
    @loan = create(:loan,
                   book: @book,
                   date: 5.days.ago.to_date,
                   expected_return: 10.days.since(Date.today),
                   reader: "Serena",
                   place: "Poggio Mirteto Scalo")
  end

  teardown do
    Loan.delete_all
    Book.delete_all
  end

  test "visiting the index" do
    visit loans_url

    assert_selector "h1", text: "Prestiti"
    assert_text @book.title
  end

  test "creating a Loan" do
    book = create(:bambina)
    visit loans_url
    click_on "Nuovo Prestito"

    page.execute_script("document.getElementById('loan_book_id').value = '#{book.id}'; document.getElementById('book_title').value = #{book.title.to_json};")
    fill_in "Data di inizio prestito", with: 5.days.ago.to_date
    fill_in "Data di restituzione attesa", with: 10.days.since(Date.today)
    fill_in "Luogo del prestito", with: "Poggio Mirteto Scalo"
    fill_in "Lettore", with: "Valeria"
    find("input[type=submit]").click

    assert_text "Loan was successfully created."
  end

  test "updating a Loan" do
    visit loans_url
    find("a[title='Modifica']", match: :first).click
    fill_in "Lettore", with: "Valeria"
    find("input[type=submit]").click

    assert_text "Loan was successfully updated."
  end

  test "destroying a Loan" do
    visit loans_url
    page.accept_confirm do
      find("a[title='Cancella']", match: :first).click
    end

    assert_text "Loan was successfully destroyed."
  end
end
