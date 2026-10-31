require "application_system_test_case"

class SequencesTest < ApplicationSystemTestCase
  setup do
    @sequence = create(:sequence)
  end

  teardown do
    Sequence.delete_all
  end

  test "visiting the index" do
    visit sequences_url

    assert_selector "h1", text: "Sequences"
    assert_text @sequence.key
  end

  test "creating a Sequence" do
    visit sequences_url
    click_on "New Sequence"

    fill_in "Key", with: "custom"
    fill_in "Value", with: "42"
    find("input[type=submit]").click

    assert_text "Sequence was successfully created."
  end
end
