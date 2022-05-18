require "application_system_test_case"

class ProposalsThemesTest < ApplicationSystemTestCase
  setup do
    @proposals_theme = proposals_themes(:one)
  end

  test "visiting the index" do
    visit proposals_themes_url
    assert_selector "h1", text: "Proposals Themes"
  end

  test "creating a Proposals theme" do
    visit proposals_themes_url
    click_on "New Proposals Theme"

    fill_in "Description", with: @proposals_theme.description
    fill_in "End date", with: @proposals_theme.end_date
    fill_in "Image", with: @proposals_theme.image
    check "Is public" if @proposals_theme.is_public
    fill_in "Start date", with: @proposals_theme.start_date
    fill_in "Title", with: @proposals_theme.title
    click_on "Create Proposals theme"

    assert_text "Proposals theme was successfully created"
    click_on "Back"
  end

  test "updating a Proposals theme" do
    visit proposals_themes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @proposals_theme.description
    fill_in "End date", with: @proposals_theme.end_date
    fill_in "Image", with: @proposals_theme.image
    check "Is public" if @proposals_theme.is_public
    fill_in "Start date", with: @proposals_theme.start_date
    fill_in "Title", with: @proposals_theme.title
    click_on "Update Proposals theme"

    assert_text "Proposals theme was successfully updated"
    click_on "Back"
  end

  test "destroying a Proposals theme" do
    visit proposals_themes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Proposals theme was successfully destroyed"
  end
end
