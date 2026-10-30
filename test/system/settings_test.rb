require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    @setting = create(:quarantine)
  end

  teardown do
    Setting.delete_all
  end

  test "visiting the index" do
    visit settings_url

    assert_selector "h1", text: "Impostazioni"
    assert_text @setting.key
  end

  test "creating a Setting" do
    visit settings_url
    click_on "Nuova Impostazione"

    fill_in "Key", with: "test"
    fill_in "Value", with: "prova"
    find("input[type=submit]").click

    assert_text "Setting was successfully created."
  end

  test "updating a Setting" do
    visit settings_url
    find("a[title='Modifica']", match: :first).click
    fill_in "Value", with: "5"
    find("input[type=submit]").click

    assert_text "Setting was successfully updated."
  end

  test "destroying a Setting" do
    visit settings_url
    page.accept_confirm do
      find("a[title='Cancella']", match: :first).click
    end

    assert_text "Setting was successfully destroyed."
  end
end
