require 'test_helper'

class FormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form = forms(:one)
  end

  test "should get index" do
    get forms_url
    assert_response :success
  end

  test "should get new" do
    get new_form_url
    assert_response :success
  end

  test "should create form" do
    assert_difference('Form.count') do
      post forms_url, params: { form: { q1: @form.q1, q1o: @form.q1o, q21: @form.q21, q21o: @form.q21o, q22: @form.q22, q22o: @form.q22o, q23: @form.q23, q23o: @form.q23o, q3: @form.q3, q41: @form.q41, q42: @form.q42, q43: @form.q43, q5: @form.q5 } }
    end

    assert_redirected_to form_url(Form.last)
  end

  test "should show form" do
    get form_url(@form)
    assert_response :success
  end

  test "should get edit" do
    get edit_form_url(@form)
    assert_response :success
  end

  test "should update form" do
    patch form_url(@form), params: { form: { q1: @form.q1, q1o: @form.q1o, q21: @form.q21, q21o: @form.q21o, q22: @form.q22, q22o: @form.q22o, q23: @form.q23, q23o: @form.q23o, q3: @form.q3, q41: @form.q41, q42: @form.q42, q43: @form.q43, q5: @form.q5 } }
    assert_redirected_to form_url(@form)
  end

  test "should destroy form" do
    assert_difference('Form.count', -1) do
      delete form_url(@form)
    end

    assert_redirected_to forms_url
  end
end
