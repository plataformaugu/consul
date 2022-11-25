require "application_system_test_case"

class ProposalTopicsTest < ApplicationSystemTestCase
  setup do
    @proposal_topic = proposal_topics(:one)
  end

  test "visiting the index" do
    visit proposal_topics_url
    assert_selector "h1", text: "Proposal Topics"
  end

  test "creating a Proposal topic" do
    visit proposal_topics_url
    click_on "New Proposal Topic"

    fill_in "Description", with: @proposal_topic.description
    fill_in "End date", with: @proposal_topic.end_date
    fill_in "Image", with: @proposal_topic.image
    fill_in "Start date", with: @proposal_topic.start_date
    fill_in "Title", with: @proposal_topic.title
    click_on "Create Proposal topic"

    assert_text "Proposal topic was successfully created"
    click_on "Back"
  end

  test "updating a Proposal topic" do
    visit proposal_topics_url
    click_on "Edit", match: :first

    fill_in "Description", with: @proposal_topic.description
    fill_in "End date", with: @proposal_topic.end_date
    fill_in "Image", with: @proposal_topic.image
    fill_in "Start date", with: @proposal_topic.start_date
    fill_in "Title", with: @proposal_topic.title
    click_on "Update Proposal topic"

    assert_text "Proposal topic was successfully updated"
    click_on "Back"
  end

  test "destroying a Proposal topic" do
    visit proposal_topics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Proposal topic was successfully destroyed"
  end
end
