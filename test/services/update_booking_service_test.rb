# frozen_string_literal: true

require "test_helper"

class UpdateBookingServiceTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  setup do
    # Freeze time so fixture dates (2026-01-31) are still in the future
    travel_to Time.zone.parse("2026-01-31 12:00:00")
    @booking = bookings(:one)
    @account = @booking.account
    @animal = animals(:one)
  end

  teardown do
    travel_back
  end

  test "updates a booking with valid attributes" do
    result = UpdateBookingService.call(
      booking: @booking,
      first_name: "Updated",
      last_name: "Name",
      pet_name: @booking.pet_name,
      pet_type: @animal.id,
      time_span: @booking.time_span,
      date_of_service: @booking.date_of_service
    )

    assert result.success?
    assert_equal "Updated", result.booking.first_name
    assert_equal "Name", result.booking.last_name
  end

  test "recalculates expected_fee when time_span or pet_type changes" do
    # expected_fee = base_service_fee + (animal_additional_hour_fee * additional_hours)
    # additional_hours = time_span - minimum_bookable_time = 3 - 1 = 2
    # 9.99 + (9.99 * 2) = 9.99 + 19.98 = 29.97
    # Use date that won't overlap with booking two (15:23-16:23) when time_span is 3
    non_overlapping_date = Time.zone.parse("2026-01-31 17:23:09")
    result = UpdateBookingService.call(
      booking: @booking,
      first_name: @booking.first_name,
      last_name: @booking.last_name,
      pet_name: @booking.pet_name,
      pet_type: @animal.id,
      time_span: 3,
      date_of_service: non_overlapping_date
    )

    assert result.success?
    assert_equal 29.97, result.booking.expected_fee
  end

  test "returns failure with errors when validation fails" do
    # Overlap with booking two (15:23, time_span 1 hour)
    overlapping_time = Time.zone.parse("2026-01-31 15:23:09")

    result = UpdateBookingService.call(
      booking: @booking,
      first_name: @booking.first_name,
      last_name: @booking.last_name,
      pet_name: @booking.pet_name,
      pet_type: @animal.id,
      time_span: 1,
      date_of_service: overlapping_time
    )

    assert_not result.success?
    assert result.booking.errors[:date_of_service].any?
  end

  test "raises when pet_type is blank" do
    # time_span 2 so additional_hours > 0 and animal_additional_hour_fee is called
    error = assert_raises(RuntimeError) do
      UpdateBookingService.call(
        booking: @booking,
        first_name: @booking.first_name,
        pet_type: nil,
        time_span: 2,
        date_of_service: @booking.date_of_service
      )
    end
    assert_match /pet type is required/i, error.message
  end

  test "raises when animal is not found for pet_type" do
    # time_span 2 so additional_hours > 0 and animal_additional_hour_fee is called
    error = assert_raises(RuntimeError) do
      UpdateBookingService.call(
        booking: @booking,
        first_name: @booking.first_name,
        pet_type: 99999,
        time_span: 2,
        date_of_service: @booking.date_of_service
      )
    end
    assert_match /animal not found/i, error.message
  end

  test "persists changes to the database" do
    UpdateBookingService.call(
      booking: @booking,
      first_name: "Saved",
      last_name: "ToDB",
      pet_name: @booking.pet_name,
      pet_type: @animal.id,
      time_span: @booking.time_span,
      date_of_service: @booking.date_of_service
    )

    @booking.reload
    assert_equal "Saved", @booking.first_name
    assert_equal "ToDB", @booking.last_name
  end

  test "sets errors on result when validation fails" do
    overlapping_time = Time.zone.parse("2026-01-31 15:23:09")

    result = UpdateBookingService.call(
      booking: @booking,
      first_name: @booking.first_name,
      last_name: @booking.last_name,
      pet_name: @booking.pet_name,
      pet_type: @animal.id,
      time_span: 1,
      date_of_service: overlapping_time
    )

    assert result.booking.errors.present?
    assert_equal result.booking.errors, result.errors
  end
end
