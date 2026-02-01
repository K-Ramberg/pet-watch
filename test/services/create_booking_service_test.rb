# frozen_string_literal: true

require "test_helper"

class CreateBookingServiceTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @animal = animals(:one)
    # Use a time that doesn't overlap existing bookings (one: 13:23, two: 15:23)
    @date_of_service = Time.zone.parse("2026-01-31 17:23:09")
  end

  test "creates a booking with valid attributes" do
    result = CreateBookingService.call(
      account: @account,
      first_name: "Jane",
      last_name: "Doe",
      pet_name: "Rex",
      pet_type: @animal.id,
      time_span: 2,
      date_of_service: @date_of_service
    )

    assert result.booking.persisted?
    assert_equal @account, result.booking.account
    assert_equal "Jane", result.booking.first_name
    assert_equal 2, result.booking.time_span
  end

  test "calculates expected_fee from base_service_fee and animal additional_hour_fee" do
    # expected_fee = base_service_fee + (animal_additional_hour_fee * additional_hours)
    # additional_hours = time_span - minimum_bookable_time = 2 - 1 = 1
    # 9.99 + (9.99 * 1) = 9.99 + 9.99 = 19.98
    result = CreateBookingService.call(
      account: @account,
      first_name: "Jane",
      last_name: "Doe",
      pet_name: "Rex",
      pet_type: @animal.id,
      time_span: 2,
      date_of_service: @date_of_service
    )

    assert result.booking.persisted?
    assert_equal 19.98, result.booking.expected_fee
  end

  test "returns failure with errors when validation fails" do
    # Overlap with existing booking one (13:23, time_span 1 hour)
    overlapping_time = Time.zone.parse("2026-01-31 13:23:09")

    result = CreateBookingService.call(
      account: @account,
      first_name: "Jane",
      last_name: "Doe",
      pet_name: "Rex",
      pet_type: @animal.id,
      time_span: 1,
      date_of_service: overlapping_time
    )

    assert_not result.booking.persisted?
    assert result.booking.errors[:date_of_service].any?
  end

  test "raises when pet_type is blank" do
    # time_span 2 so additional_hours > 0 and animal_additional_hour_fee is called
    error = assert_raises(RuntimeError) do
      CreateBookingService.call(
        account: @account,
        first_name: "Jane",
        pet_type: nil,
        time_span: 2,
        date_of_service: @date_of_service
      )
    end
    assert_match /pet type is required/i, error.message
  end

  test "raises when animal is not found for pet_type" do
    # time_span 2 so additional_hours > 0 and animal_additional_hour_fee is called
    error = assert_raises(RuntimeError) do
      CreateBookingService.call(
        account: @account,
        first_name: "Jane",
        pet_type: 99999,
        time_span: 2,
        date_of_service: @date_of_service
      )
    end
    assert_match /animal not found/i, error.message
  end
end
