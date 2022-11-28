require 'test_helper'

class SocialOrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @social_organization = social_organizations(:one)
  end

  test "should get index" do
    get social_organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_social_organization_url
    assert_response :success
  end

  test "should create social_organization" do
    assert_difference('SocialOrganization.count') do
      post social_organizations_url, params: { social_organization: { description: @social_organization.description, email: @social_organization.email, name: @social_organization.name, url: @social_organization.url, user_id: @social_organization.user_id } }
    end

    assert_redirected_to social_organization_url(SocialOrganization.last)
  end

  test "should show social_organization" do
    get social_organization_url(@social_organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_social_organization_url(@social_organization)
    assert_response :success
  end

  test "should update social_organization" do
    patch social_organization_url(@social_organization), params: { social_organization: { description: @social_organization.description, email: @social_organization.email, name: @social_organization.name, url: @social_organization.url, user_id: @social_organization.user_id } }
    assert_redirected_to social_organization_url(@social_organization)
  end

  test "should destroy social_organization" do
    assert_difference('SocialOrganization.count', -1) do
      delete social_organization_url(@social_organization)
    end

    assert_redirected_to social_organizations_url
  end
end
