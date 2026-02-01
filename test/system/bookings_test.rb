require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one)
    @booking = bookings(:one)
    @animal = animals(:one)
    # Time that doesn't overlap fixtures (one: 13:23-14:23, two: 15:23-16:23)
    @non_overlapping_datetime = Time.zone.parse("2026-01-31 17:23:00")
  end

  test "visiting the index" do
    visit account_bookings_url(@account)
    assert_selector "h1", text: /Upcoming Bookings/
  end

  test "booking form creates booking when valid" do
    visit account_bookings_url(@account)
    click_on "Create new booking"

    assert_selector "h1", text: "New booking"
    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Doe"
    fill_in "Pet name", with: "Rex"
    select @animal.name, from: "Pet type"
    fill_in "Time span", with: "2"
    fill_in "Date of service", with: @non_overlapping_datetime.strftime("%Y-%m-%dT%H:%M")
    click_on "Create Booking"

    assert_text "Booking was successfully created"
    assert_current_path account_bookings_path(@account)
    assert_text "Jane"
  end

  test "booking form shows validation errors when invalid" do
    visit new_account_booking_url(@account)

    fill_in "First name", with: ""
    fill_in "Last name", with: ""
    select "Select an animal", from: "Pet type"
    click_on "Create Booking"

    assert_text "error"
    assert_selector "h1", text: "New booking"
  end

  test "booking form shows validation error when date overlaps" do
    visit new_account_booking_url(@account)

    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Doe"
    fill_in "Pet name", with: "Rex"
    select @animal.name, from: "Pet type"
    fill_in "Time span", with: "2"
    # Overlap with booking one (13:23, time_span 1 -> 13:23-14:23)
    fill_in "Date of service", with: Time.zone.parse("2026-01-31 13:30:00").strftime("%Y-%m-%dT%H:%M")
    click_on "Create Booking"

    assert_text "error"
    assert_selector "h1", text: "New booking"
  end

  test "booking form updates booking when valid" do
    visit booking_url(@booking)
    click_on "Edit this booking", match: :first

    assert_selector "h1", text: "Editing Booking"
    fill_in "First name", with: "Updated"
    fill_in "Last name", with: "Client"
    click_on "Update Booking"

    assert_text "Booking was successfully updated"
    assert_text "Updated"
  end

  test "booking form shows validation errors on edit when invalid" do
    visit edit_booking_url(@booking)

    fill_in "First name", with: ""
    click_on "Update Booking"

    assert_text "error"
    assert_selector "h1", text: "Editing Booking"
  end

  test "should destroy Booking" do
    visit booking_url(@booking)
    click_on "Destroy this booking", match: :first

    assert_text "Booking was successfully destroyed"
  end
end
