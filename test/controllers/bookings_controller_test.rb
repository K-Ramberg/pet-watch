require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
    @animal = animals(:one) # CreateBookingService looks up Animal by pet_type (animal id)
  end

  test "should get index" do
    get account_bookings_url(@booking.account)
    assert_response :success
  end

  test "should get new" do
    get new_account_booking_url(@booking.account)
    assert_response :success
  end

  test "should create booking" do
    # Use a date_of_service that doesn't overlap with existing fixtures (one: 13:23, two: 15:23)
    non_overlapping_time = @booking.date_of_service + 4.hours
    assert_difference("Booking.count") do
      post account_bookings_url(@booking.account), params: { booking: { account_id: @booking.account_id, date_of_service: non_overlapping_time, expected_fee: @booking.expected_fee, first_name: @booking.first_name, last_name: @booking.last_name, pet_name: @booking.pet_name, pet_type: @animal.id, time_span: @booking.time_span } }
    end

    assert_redirected_to account_bookings_url(@booking.account)
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
    patch booking_url(@booking), params: { booking: { account_id: @booking.account_id, date_of_service: @booking.date_of_service, expected_fee: @booking.expected_fee, first_name: @booking.first_name, last_name: @booking.last_name, pet_name: @booking.pet_name, pet_type: @animal.id, time_span: @booking.time_span } }
    assert_redirected_to booking_url(@booking)
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to account_bookings_url(@booking.account)
  end
end
