require 'test_helper'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quiz = quizzes(:one)
  end

  test "should get index" do
    get quizzes_url
    assert_response :success
  end

  test "should get new" do
    get new_quiz_url
    assert_response :success
  end

  test "should create quiz" do
    assert_difference('Quiz.count') do
      post quizzes_url, params: { quiz: { description: @quiz.description, name: @quiz.name, q1: @quiz.q1, q2: @quiz.q2, q3: @quiz.q3, q4: @quiz.q4, q5: @quiz.q5, quiz_type: @quiz.quiz_type, user_id: @quiz.user_id, visible: @quiz.visible } }
    end

    assert_redirected_to quiz_url(Quiz.last)
  end

  test "should show quiz" do
    get quiz_url(@quiz)
    assert_response :success
  end

  test "should get edit" do
    get edit_quiz_url(@quiz)
    assert_response :success
  end

  test "should update quiz" do
    patch quiz_url(@quiz), params: { quiz: { description: @quiz.description, name: @quiz.name, q1: @quiz.q1, q2: @quiz.q2, q3: @quiz.q3, q4: @quiz.q4, q5: @quiz.q5, quiz_type: @quiz.quiz_type, user_id: @quiz.user_id, visible: @quiz.visible } }
    assert_redirected_to quiz_url(@quiz)
  end

  test "should destroy quiz" do
    assert_difference('Quiz.count', -1) do
      delete quiz_url(@quiz)
    end

    assert_redirected_to quizzes_url
  end
end
