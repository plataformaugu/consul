require "application_system_test_case"

class NeighborhoodCouncilEventsTest < ApplicationSystemTestCase
  setup do
    @neighborhood_council_event = neighborhood_council_events(:one)
  end

  test "visiting the index" do
    visit neighborhood_council_events_url
    assert_selector "h1", text: "Neighborhood Council Events"
  end

  test "creating a Neighborhood council event" do
    visit neighborhood_council_events_url
    click_on "New Neighborhood Council Event"

    fill_in "Email", with: @neighborhood_council_event.email
    fill_in "Event", with: @neighborhood_council_event.event_id
    fill_in "Name", with: @neighborhood_council_event.name
    fill_in "Neighborhood council", with: @neighborhood_council_event.neighborhood_council_id
    fill_in "Phone number", with: @neighborhood_council_event.phone_number
    fill_in "Place", with: @neighborhood_council_event.place
    click_on "Create Neighborhood council event"

    assert_text "Neighborhood council event was successfully created"
    click_on "Back"
  end

  test "updating a Neighborhood council event" do
    visit neighborhood_council_events_url
    click_on "Edit", match: :first

    fill_in "Email", with: @neighborhood_council_event.email
    fill_in "Event", with: @neighborhood_council_event.event_id
    fill_in "Name", with: @neighborhood_council_event.name
    fill_in "Neighborhood council", with: @neighborhood_council_event.neighborhood_council_id
    fill_in "Phone number", with: @neighborhood_council_event.phone_number
    fill_in "Place", with: @neighborhood_council_event.place
    click_on "Update Neighborhood council event"

    assert_text "Neighborhood council event was successfully updated"
    click_on "Back"
  end

  test "destroying a Neighborhood council event" do
    visit neighborhood_council_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Neighborhood council event was successfully destroyed"
  end
end
