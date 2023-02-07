require 'test_helper'

class NeighborhoodCouncilEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @neighborhood_council_event = neighborhood_council_events(:one)
  end

  test "should get index" do
    get neighborhood_council_events_url
    assert_response :success
  end

  test "should get new" do
    get new_neighborhood_council_event_url
    assert_response :success
  end

  test "should create neighborhood_council_event" do
    assert_difference('NeighborhoodCouncilEvent.count') do
      post neighborhood_council_events_url, params: { neighborhood_council_event: { email: @neighborhood_council_event.email, event_id: @neighborhood_council_event.event_id, name: @neighborhood_council_event.name, neighborhood_council_id: @neighborhood_council_event.neighborhood_council_id, phone_number: @neighborhood_council_event.phone_number, place: @neighborhood_council_event.place } }
    end

    assert_redirected_to neighborhood_council_event_url(NeighborhoodCouncilEvent.last)
  end

  test "should show neighborhood_council_event" do
    get neighborhood_council_event_url(@neighborhood_council_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_neighborhood_council_event_url(@neighborhood_council_event)
    assert_response :success
  end

  test "should update neighborhood_council_event" do
    patch neighborhood_council_event_url(@neighborhood_council_event), params: { neighborhood_council_event: { email: @neighborhood_council_event.email, event_id: @neighborhood_council_event.event_id, name: @neighborhood_council_event.name, neighborhood_council_id: @neighborhood_council_event.neighborhood_council_id, phone_number: @neighborhood_council_event.phone_number, place: @neighborhood_council_event.place } }
    assert_redirected_to neighborhood_council_event_url(@neighborhood_council_event)
  end

  test "should destroy neighborhood_council_event" do
    assert_difference('NeighborhoodCouncilEvent.count', -1) do
      delete neighborhood_council_event_url(@neighborhood_council_event)
    end

    assert_redirected_to neighborhood_council_events_url
  end
end
