require "application_system_test_case"

class SocialOrganizationsTest < ApplicationSystemTestCase
  setup do
    @social_organization = social_organizations(:one)
  end

  test "visiting the index" do
    visit social_organizations_url
    assert_selector "h1", text: "Social Organizations"
  end

  test "creating a Social organization" do
    visit social_organizations_url
    click_on "New Social Organization"

    fill_in "Description", with: @social_organization.description
    fill_in "Email", with: @social_organization.email
    fill_in "Name", with: @social_organization.name
    fill_in "Url", with: @social_organization.url
    fill_in "User", with: @social_organization.user_id
    click_on "Create Social organization"

    assert_text "Social organization was successfully created"
    click_on "Back"
  end

  test "updating a Social organization" do
    visit social_organizations_url
    click_on "Edit", match: :first

    fill_in "Description", with: @social_organization.description
    fill_in "Email", with: @social_organization.email
    fill_in "Name", with: @social_organization.name
    fill_in "Url", with: @social_organization.url
    fill_in "User", with: @social_organization.user_id
    click_on "Update Social organization"

    assert_text "Social organization was successfully updated"
    click_on "Back"
  end

  test "destroying a Social organization" do
    visit social_organizations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Social organization was successfully destroyed"
  end
end
