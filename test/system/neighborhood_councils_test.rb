require "application_system_test_case"

class NeighborhoodCouncilsTest < ApplicationSystemTestCase
  setup do
    @neighborhood_council = neighborhood_councils(:one)
  end

  test "visiting the index" do
    visit neighborhood_councils_url
    assert_selector "h1", text: "Neighborhood Councils"
  end

  test "creating a Neighborhood council" do
    visit neighborhood_councils_url
    click_on "New Neighborhood Council"

    fill_in "Address", with: @neighborhood_council.address
    fill_in "Conformation date", with: @neighborhood_council.conformation_date
    fill_in "Email", with: @neighborhood_council.email
    fill_in "Name", with: @neighborhood_council.name
    fill_in "Phone number", with: @neighborhood_council.phone_number
    fill_in "Sector", with: @neighborhood_council.sector_id
    click_on "Create Neighborhood council"

    assert_text "Neighborhood council was successfully created"
    click_on "Back"
  end

  test "updating a Neighborhood council" do
    visit neighborhood_councils_url
    click_on "Edit", match: :first

    fill_in "Address", with: @neighborhood_council.address
    fill_in "Conformation date", with: @neighborhood_council.conformation_date
    fill_in "Email", with: @neighborhood_council.email
    fill_in "Name", with: @neighborhood_council.name
    fill_in "Phone number", with: @neighborhood_council.phone_number
    fill_in "Sector", with: @neighborhood_council.sector_id
    click_on "Update Neighborhood council"

    assert_text "Neighborhood council was successfully updated"
    click_on "Back"
  end

  test "destroying a Neighborhood council" do
    visit neighborhood_councils_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Neighborhood council was successfully destroyed"
  end
end
