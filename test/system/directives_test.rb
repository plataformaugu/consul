require "application_system_test_case"

class DirectivesTest < ApplicationSystemTestCase
  setup do
    @directive = directives(:one)
  end

  test "visiting the index" do
    visit directives_url
    assert_selector "h1", text: "Directives"
  end

  test "creating a Directive" do
    visit directives_url
    click_on "New Directive"

    fill_in "Email", with: @directive.email
    fill_in "Full name", with: @directive.full_name
    fill_in "Neighborhood council", with: @directive.neighborhood_council_id
    fill_in "Phone number", with: @directive.phone_number
    fill_in "Position", with: @directive.position
    fill_in "Profession", with: @directive.profession
    click_on "Create Directive"

    assert_text "Directive was successfully created"
    click_on "Back"
  end

  test "updating a Directive" do
    visit directives_url
    click_on "Edit", match: :first

    fill_in "Email", with: @directive.email
    fill_in "Full name", with: @directive.full_name
    fill_in "Neighborhood council", with: @directive.neighborhood_council_id
    fill_in "Phone number", with: @directive.phone_number
    fill_in "Position", with: @directive.position
    fill_in "Profession", with: @directive.profession
    click_on "Update Directive"

    assert_text "Directive was successfully updated"
    click_on "Back"
  end

  test "destroying a Directive" do
    visit directives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Directive was successfully destroyed"
  end
end
