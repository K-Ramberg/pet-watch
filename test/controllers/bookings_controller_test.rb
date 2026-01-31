require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should get new" do
    get new_booking_url
    assert_response :success
  end

  test "should create booking" do
    assert_difference("Booking.count") do
      post bookings_url, params: { booking: { date_of_service: @booking.date_of_service, expected_fee: @booking.expected_fee, first_name: @booking.first_name, last_name: @booking.last_name, pet_name: @booking.pet_name, pet_type: @booking.pet_type, time_span: @booking.time_span } }
    end

    assert_redirected_to booking_url(Booking.last)
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should get edit" do
    get edit_booking_url(@booking)
    assert_response :success
  end

  test "should update booking" do
    patch booking_url(@booking), params: { booking: { date_of_service: @booking.date_of_service, expected_fee: @booking.expected_fee, first_name: @booking.first_name, last_name: @booking.last_name, pet_name: @booking.pet_name, pet_type: @booking.pet_type, time_span: @booking.time_span } }
    assert_redirected_to booking_url(@booking)
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to bookings_url
  end
end
