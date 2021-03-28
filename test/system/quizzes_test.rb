require "application_system_test_case"

class QuizzesTest < ApplicationSystemTestCase
  setup do
    @quiz = quizzes(:one)
  end

  test "visiting the index" do
    visit quizzes_url
    assert_selector "h1", text: "Quizzes"
  end

  test "creating a Quiz" do
    visit quizzes_url
    click_on "New Quiz"

    fill_in "Description", with: @quiz.description
    fill_in "Name", with: @quiz.name
    fill_in "Q1", with: @quiz.q1
    fill_in "Q2", with: @quiz.q2
    fill_in "Q3", with: @quiz.q3
    fill_in "Q4", with: @quiz.q4
    fill_in "Q5", with: @quiz.q5
    fill_in "Quiz type", with: @quiz.quiz_type
    fill_in "User", with: @quiz.user_id
    check "Visible" if @quiz.visible
    click_on "Create Quiz"

    assert_text "Quiz was successfully created"
    click_on "Back"
  end

  test "updating a Quiz" do
    visit quizzes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @quiz.description
    fill_in "Name", with: @quiz.name
    fill_in "Q1", with: @quiz.q1
    fill_in "Q2", with: @quiz.q2
    fill_in "Q3", with: @quiz.q3
    fill_in "Q4", with: @quiz.q4
    fill_in "Q5", with: @quiz.q5
    fill_in "Quiz type", with: @quiz.quiz_type
    fill_in "User", with: @quiz.user_id
    check "Visible" if @quiz.visible
    click_on "Update Quiz"

    assert_text "Quiz was successfully updated"
    click_on "Back"
  end

  test "destroying a Quiz" do
    visit quizzes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Quiz was successfully destroyed"
  end
end
