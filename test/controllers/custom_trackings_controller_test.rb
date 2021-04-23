require 'test_helper'

class CustomTrackingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @custom_tracking = custom_trackings(:one)
  end

  test "should get index" do
    get custom_trackings_url
    assert_response :success
  end

  test "should get new" do
    get new_custom_tracking_url
    assert_response :success
  end

  test "should create custom_tracking" do
    assert_difference('CustomTracking.count') do
      post custom_trackings_url, params: { custom_tracking: { count: @custom_tracking.count, page: @custom_tracking.page } }
    end

    assert_redirected_to custom_tracking_url(CustomTracking.last)
  end

  test "should show custom_tracking" do
    get custom_tracking_url(@custom_tracking)
    assert_response :success
  end

  test "should get edit" do
    get edit_custom_tracking_url(@custom_tracking)
    assert_response :success
  end

  test "should update custom_tracking" do
    patch custom_tracking_url(@custom_tracking), params: { custom_tracking: { count: @custom_tracking.count, page: @custom_tracking.page } }
    assert_redirected_to custom_tracking_url(@custom_tracking)
  end

  test "should destroy custom_tracking" do
    assert_difference('CustomTracking.count', -1) do
      delete custom_tracking_url(@custom_tracking)
    end

    assert_redirected_to custom_trackings_url
  end
end
