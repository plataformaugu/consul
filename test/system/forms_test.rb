require "application_system_test_case"

class FormsTest < ApplicationSystemTestCase
  setup do
    @form = forms(:one)
  end

  test "visiting the index" do
    visit forms_url
    assert_selector "h1", text: "Forms"
  end

  test "creating a Form" do
    visit forms_url
    click_on "New Form"

    fill_in "Q1", with: @form.q1
    fill_in "Q1o", with: @form.q1o
    fill_in "Q21", with: @form.q21
    fill_in "Q21o", with: @form.q21o
    fill_in "Q22", with: @form.q22
    fill_in "Q22o", with: @form.q22o
    fill_in "Q23", with: @form.q23
    fill_in "Q23o", with: @form.q23o
    fill_in "Q3", with: @form.q3
    fill_in "Q41", with: @form.q41
    fill_in "Q42", with: @form.q42
    fill_in "Q43", with: @form.q43
    fill_in "Q5", with: @form.q5
    click_on "Create Form"

    assert_text "Form was successfully created"
    click_on "Back"
  end

  test "updating a Form" do
    visit forms_url
    click_on "Edit", match: :first

    fill_in "Q1", with: @form.q1
    fill_in "Q1o", with: @form.q1o
    fill_in "Q21", with: @form.q21
    fill_in "Q21o", with: @form.q21o
    fill_in "Q22", with: @form.q22
    fill_in "Q22o", with: @form.q22o
    fill_in "Q23", with: @form.q23
    fill_in "Q23o", with: @form.q23o
    fill_in "Q3", with: @form.q3
    fill_in "Q41", with: @form.q41
    fill_in "Q42", with: @form.q42
    fill_in "Q43", with: @form.q43
    fill_in "Q5", with: @form.q5
    click_on "Update Form"

    assert_text "Form was successfully updated"
    click_on "Back"
  end

  test "destroying a Form" do
    visit forms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Form was successfully destroyed"
  end
end
