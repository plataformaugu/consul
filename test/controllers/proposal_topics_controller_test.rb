require 'test_helper'

class ProposalTopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proposal_topic = proposal_topics(:one)
  end

  test "should get index" do
    get proposal_topics_url
    assert_response :success
  end

  test "should get new" do
    get new_proposal_topic_url
    assert_response :success
  end

  test "should create proposal_topic" do
    assert_difference('ProposalTopic.count') do
      post proposal_topics_url, params: { proposal_topic: { description: @proposal_topic.description, end_date: @proposal_topic.end_date, image: @proposal_topic.image, start_date: @proposal_topic.start_date, title: @proposal_topic.title } }
    end

    assert_redirected_to proposal_topic_url(ProposalTopic.last)
  end

  test "should show proposal_topic" do
    get proposal_topic_url(@proposal_topic)
    assert_response :success
  end

  test "should get edit" do
    get edit_proposal_topic_url(@proposal_topic)
    assert_response :success
  end

  test "should update proposal_topic" do
    patch proposal_topic_url(@proposal_topic), params: { proposal_topic: { description: @proposal_topic.description, end_date: @proposal_topic.end_date, image: @proposal_topic.image, start_date: @proposal_topic.start_date, title: @proposal_topic.title } }
    assert_redirected_to proposal_topic_url(@proposal_topic)
  end

  test "should destroy proposal_topic" do
    assert_difference('ProposalTopic.count', -1) do
      delete proposal_topic_url(@proposal_topic)
    end

    assert_redirected_to proposal_topics_url
  end
end
