require 'test_helper'

class FunctionalOrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @functional_organization = functional_organizations(:one)
  end

  test "should get index" do
    get functional_organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_functional_organization_url
    assert_response :success
  end

  test "should create functional_organization" do
    assert_difference('FunctionalOrganization.count') do
      post functional_organizations_url, params: { functional_organization: { address: @functional_organization.address, conformation_date: @functional_organization.conformation_date, email: @functional_organization.email, facebook: @functional_organization.facebook, instagram: @functional_organization.instagram, main_theme_id: @functional_organization.main_theme_id, mission: @functional_organization.mission, name: @functional_organization.name, phone_number: @functional_organization.phone_number, president_name: @functional_organization.president_name, twitter: @functional_organization.twitter, url: @functional_organization.url, view: @functional_organization.view, whatsapp: @functional_organization.whatsapp } }
    end

    assert_redirected_to functional_organization_url(FunctionalOrganization.last)
  end

  test "should show functional_organization" do
    get functional_organization_url(@functional_organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_functional_organization_url(@functional_organization)
    assert_response :success
  end

  test "should update functional_organization" do
    patch functional_organization_url(@functional_organization), params: { functional_organization: { address: @functional_organization.address, conformation_date: @functional_organization.conformation_date, email: @functional_organization.email, facebook: @functional_organization.facebook, instagram: @functional_organization.instagram, main_theme_id: @functional_organization.main_theme_id, mission: @functional_organization.mission, name: @functional_organization.name, phone_number: @functional_organization.phone_number, president_name: @functional_organization.president_name, twitter: @functional_organization.twitter, url: @functional_organization.url, view: @functional_organization.view, whatsapp: @functional_organization.whatsapp } }
    assert_redirected_to functional_organization_url(@functional_organization)
  end

  test "should destroy functional_organization" do
    assert_difference('FunctionalOrganization.count', -1) do
      delete functional_organization_url(@functional_organization)
    end

    assert_redirected_to functional_organizations_url
  end
end
