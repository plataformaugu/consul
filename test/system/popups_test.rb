require "application_system_test_case"

class PopupsTest < ApplicationSystemTestCase
  setup do
    @popup = popups(:one)
  end

  test "visiting the index" do
    visit popups_url
    assert_selector "h1", text: "Popups"
  end

  test "creating a Popup" do
    visit popups_url
    click_on "New Popup"

    fill_in "Image", with: @popup.image
    check "Is active" if @popup.is_active
    fill_in "Url", with: @popup.url
    click_on "Create Popup"

    assert_text "Popup was successfully created"
    click_on "Back"
  end

  test "updating a Popup" do
    visit popups_url
    click_on "Edit", match: :first

    fill_in "Image", with: @popup.image
    check "Is active" if @popup.is_active
    fill_in "Url", with: @popup.url
    click_on "Update Popup"

    assert_text "Popup was successfully updated"
    click_on "Back"
  end

  test "destroying a Popup" do
    visit popups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Popup was successfully destroyed"
  end
end
