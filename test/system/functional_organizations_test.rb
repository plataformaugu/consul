require "application_system_test_case"

class FunctionalOrganizationsTest < ApplicationSystemTestCase
  setup do
    @functional_organization = functional_organizations(:one)
  end

  test "visiting the index" do
    visit functional_organizations_url
    assert_selector "h1", text: "Functional Organizations"
  end

  test "creating a Functional organization" do
    visit functional_organizations_url
    click_on "New Functional Organization"

    fill_in "Address", with: @functional_organization.address
    fill_in "Conformation date", with: @functional_organization.conformation_date
    fill_in "Email", with: @functional_organization.email
    fill_in "Facebook", with: @functional_organization.facebook
    fill_in "Instagram", with: @functional_organization.instagram
    fill_in "Main theme", with: @functional_organization.main_theme_id
    fill_in "Mission", with: @functional_organization.mission
    fill_in "Name", with: @functional_organization.name
    fill_in "Phone number", with: @functional_organization.phone_number
    fill_in "President name", with: @functional_organization.president_name
    fill_in "Twitter", with: @functional_organization.twitter
    fill_in "Url", with: @functional_organization.url
    fill_in "View", with: @functional_organization.view
    fill_in "Whatsapp", with: @functional_organization.whatsapp
    click_on "Create Functional organization"

    assert_text "Functional organization was successfully created"
    click_on "Back"
  end

  test "updating a Functional organization" do
    visit functional_organizations_url
    click_on "Edit", match: :first

    fill_in "Address", with: @functional_organization.address
    fill_in "Conformation date", with: @functional_organization.conformation_date
    fill_in "Email", with: @functional_organization.email
    fill_in "Facebook", with: @functional_organization.facebook
    fill_in "Instagram", with: @functional_organization.instagram
    fill_in "Main theme", with: @functional_organization.main_theme_id
    fill_in "Mission", with: @functional_organization.mission
    fill_in "Name", with: @functional_organization.name
    fill_in "Phone number", with: @functional_organization.phone_number
    fill_in "President name", with: @functional_organization.president_name
    fill_in "Twitter", with: @functional_organization.twitter
    fill_in "Url", with: @functional_organization.url
    fill_in "View", with: @functional_organization.view
    fill_in "Whatsapp", with: @functional_organization.whatsapp
    click_on "Update Functional organization"

    assert_text "Functional organization was successfully updated"
    click_on "Back"
  end

  test "destroying a Functional organization" do
    visit functional_organizations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Functional organization was successfully destroyed"
  end
end
