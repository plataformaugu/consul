require "application_system_test_case"

class CustomTrackingsTest < ApplicationSystemTestCase
  setup do
    @custom_tracking = custom_trackings(:one)
  end

  test "visiting the index" do
    visit custom_trackings_url
    assert_selector "h1", text: "Custom Trackings"
  end

  test "creating a Custom tracking" do
    visit custom_trackings_url
    click_on "New Custom Tracking"

    fill_in "Count", with: @custom_tracking.count
    fill_in "Page", with: @custom_tracking.page
    click_on "Create Custom tracking"

    assert_text "Custom tracking was successfully created"
    click_on "Back"
  end

  test "updating a Custom tracking" do
    visit custom_trackings_url
    click_on "Edit", match: :first

    fill_in "Count", with: @custom_tracking.count
    fill_in "Page", with: @custom_tracking.page
    click_on "Update Custom tracking"

    assert_text "Custom tracking was successfully updated"
    click_on "Back"
  end

  test "destroying a Custom tracking" do
    visit custom_trackings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Custom tracking was successfully destroyed"
  end
end
