require 'test_helper'

class ProposalsThemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proposals_theme = proposals_themes(:one)
  end

  test "should get index" do
    get proposals_themes_url
    assert_response :success
  end

  test "should get new" do
    get new_proposals_theme_url
    assert_response :success
  end

  test "should create proposals_theme" do
    assert_difference('ProposalsTheme.count') do
      post proposals_themes_url, params: { proposals_theme: { description: @proposals_theme.description, end_date: @proposals_theme.end_date, image: @proposals_theme.image, is_public: @proposals_theme.is_public, start_date: @proposals_theme.start_date, title: @proposals_theme.title } }
    end

    assert_redirected_to proposals_theme_url(ProposalsTheme.last)
  end

  test "should show proposals_theme" do
    get proposals_theme_url(@proposals_theme)
    assert_response :success
  end

  test "should get edit" do
    get edit_proposals_theme_url(@proposals_theme)
    assert_response :success
  end

  test "should update proposals_theme" do
    patch proposals_theme_url(@proposals_theme), params: { proposals_theme: { description: @proposals_theme.description, end_date: @proposals_theme.end_date, image: @proposals_theme.image, is_public: @proposals_theme.is_public, start_date: @proposals_theme.start_date, title: @proposals_theme.title } }
    assert_redirected_to proposals_theme_url(@proposals_theme)
  end

  test "should destroy proposals_theme" do
    assert_difference('ProposalsTheme.count', -1) do
      delete proposals_theme_url(@proposals_theme)
    end

    assert_redirected_to proposals_themes_url
  end
end
