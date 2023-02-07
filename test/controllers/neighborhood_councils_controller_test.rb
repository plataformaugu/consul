require 'test_helper'

class NeighborhoodCouncilsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @neighborhood_council = neighborhood_councils(:one)
  end

  test "should get index" do
    get neighborhood_councils_url
    assert_response :success
  end

  test "should get new" do
    get new_neighborhood_council_url
    assert_response :success
  end

  test "should create neighborhood_council" do
    assert_difference('NeighborhoodCouncil.count') do
      post neighborhood_councils_url, params: { neighborhood_council: { address: @neighborhood_council.address, conformation_date: @neighborhood_council.conformation_date, email: @neighborhood_council.email, name: @neighborhood_council.name, phone_number: @neighborhood_council.phone_number, sector_id: @neighborhood_council.sector_id } }
    end

    assert_redirected_to neighborhood_council_url(NeighborhoodCouncil.last)
  end

  test "should show neighborhood_council" do
    get neighborhood_council_url(@neighborhood_council)
    assert_response :success
  end

  test "should get edit" do
    get edit_neighborhood_council_url(@neighborhood_council)
    assert_response :success
  end

  test "should update neighborhood_council" do
    patch neighborhood_council_url(@neighborhood_council), params: { neighborhood_council: { address: @neighborhood_council.address, conformation_date: @neighborhood_council.conformation_date, email: @neighborhood_council.email, name: @neighborhood_council.name, phone_number: @neighborhood_council.phone_number, sector_id: @neighborhood_council.sector_id } }
    assert_redirected_to neighborhood_council_url(@neighborhood_council)
  end

  test "should destroy neighborhood_council" do
    assert_difference('NeighborhoodCouncil.count', -1) do
      delete neighborhood_council_url(@neighborhood_council)
    end

    assert_redirected_to neighborhood_councils_url
  end
end
