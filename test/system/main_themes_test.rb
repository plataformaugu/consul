require "application_system_test_case"

class MainThemesTest < ApplicationSystemTestCase
  setup do
    @main_theme = main_themes(:one)
  end

  test "visiting the index" do
    visit main_themes_url
    assert_selector "h1", text: "Main Themes"
  end

  test "creating a Main theme" do
    visit main_themes_url
    click_on "New Main Theme"

    fill_in "Description", with: @main_theme.description
    fill_in "Extra image", with: @main_theme.extra_image
    fill_in "Icon", with: @main_theme.icon
    fill_in "Image", with: @main_theme.image
    fill_in "Name", with: @main_theme.name
    fill_in "Primary color", with: @main_theme.primary_color
    fill_in "Secondary color", with: @main_theme.secondary_color
    click_on "Create Main theme"

    assert_text "Main theme was successfully created"
    click_on "Back"
  end

  test "updating a Main theme" do
    visit main_themes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @main_theme.description
    fill_in "Extra image", with: @main_theme.extra_image
    fill_in "Icon", with: @main_theme.icon
    fill_in "Image", with: @main_theme.image
    fill_in "Name", with: @main_theme.name
    fill_in "Primary color", with: @main_theme.primary_color
    fill_in "Secondary color", with: @main_theme.secondary_color
    click_on "Update Main theme"

    assert_text "Main theme was successfully updated"
    click_on "Back"
  end

  test "destroying a Main theme" do
    visit main_themes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Main theme was successfully destroyed"
  end
end
