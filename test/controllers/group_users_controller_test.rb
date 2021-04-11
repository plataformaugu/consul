require 'test_helper'

class GroupUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_user = group_users(:one)
  end

  test "should get index" do
    get group_users_url
    assert_response :success
  end

  test "should get new" do
    get new_group_user_url
    assert_response :success
  end

  test "should create group_user" do
    assert_difference('GroupUser.count') do
      post group_users_url, params: { group_user: { email: @group_user.email, name: @group_user.name, rut: @group_user.rut } }
    end

    assert_redirected_to group_user_url(GroupUser.last)
  end

  test "should show group_user" do
    get group_user_url(@group_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_user_url(@group_user)
    assert_response :success
  end

  test "should update group_user" do
    patch group_user_url(@group_user), params: { group_user: { email: @group_user.email, name: @group_user.name, rut: @group_user.rut } }
    assert_redirected_to group_user_url(@group_user)
  end

  test "should destroy group_user" do
    assert_difference('GroupUser.count', -1) do
      delete group_user_url(@group_user)
    end

    assert_redirected_to group_users_url
  end
end