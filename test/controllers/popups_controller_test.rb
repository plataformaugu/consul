require 'test_helper'

class PopupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @popup = popups(:one)
  end

  test "should get index" do
    get popups_url
    assert_response :success
  end

  test "should get new" do
    get new_popup_url
    assert_response :success
  end

  test "should create popup" do
    assert_difference('Popup.count') do
      post popups_url, params: { popup: { image: @popup.image, is_active: @popup.is_active, url: @popup.url } }
    end

    assert_redirected_to popup_url(Popup.last)
  end

  test "should show popup" do
    get popup_url(@popup)
    assert_response :success
  end

  test "should get edit" do
    get edit_popup_url(@popup)
    assert_response :success
  end

  test "should update popup" do
    patch popup_url(@popup), params: { popup: { image: @popup.image, is_active: @popup.is_active, url: @popup.url } }
    assert_redirected_to popup_url(@popup)
  end

  test "should destroy popup" do
    assert_difference('Popup.count', -1) do
      delete popup_url(@popup)
    end

    assert_redirected_to popups_url
  end
end
