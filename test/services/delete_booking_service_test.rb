# frozen_string_literal: true

require "test_helper"

class DeleteBookingServiceTest < ActiveSupport::TestCase
  setup do
    @booking = bookings(:one)
  end

  test "destroys the booking" do
    assert_difference("Booking.count", -1) do
      DeleteBookingService.call(booking: @booking)
    end

    assert @booking.destroyed?
  end

  test "returns success when booking is destroyed" do
    result = DeleteBookingService.call(booking: @booking)

    assert result.success?
    assert result.booking.destroyed?
  end

  test "returns self" do
    result = DeleteBookingService.call(booking: @booking)

    assert_instance_of DeleteBookingService, result
  end

  test "booking is removed from database after destroy" do
    booking_id = @booking.id

    DeleteBookingService.call(booking: @booking)

    assert_nil Booking.find_by(id: booking_id)
  end

  test "exposes the same booking that was passed in" do
    result = DeleteBookingService.call(booking: @booking)

    assert_equal @booking, result.booking
  end
end
