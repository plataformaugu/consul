require 'test_helper'

class DirectivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @directive = directives(:one)
  end

  test "should get index" do
    get directives_url
    assert_response :success
  end

  test "should get new" do
    get new_directive_url
    assert_response :success
  end

  test "should create directive" do
    assert_difference('Directive.count') do
      post directives_url, params: { directive: { email: @directive.email, full_name: @directive.full_name, neighborhood_council_id: @directive.neighborhood_council_id, phone_number: @directive.phone_number, position: @directive.position, profession: @directive.profession } }
    end

    assert_redirected_to directive_url(Directive.last)
  end

  test "should show directive" do
    get directive_url(@directive)
    assert_response :success
  end

  test "should get edit" do
    get edit_directive_url(@directive)
    assert_response :success
  end

  test "should update directive" do
    patch directive_url(@directive), params: { directive: { email: @directive.email, full_name: @directive.full_name, neighborhood_council_id: @directive.neighborhood_council_id, phone_number: @directive.phone_number, position: @directive.position, profession: @directive.profession } }
    assert_redirected_to directive_url(@directive)
  end

  test "should destroy directive" do
    assert_difference('Directive.count', -1) do
      delete directive_url(@directive)
    end

    assert_redirected_to directives_url
  end
end
