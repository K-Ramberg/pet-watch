# frozen_string_literal: true

class UpdateBookingService
  include Bookingable

  attr_reader :booking, :errors

  def self.call(booking:, **attributes)
    new(booking: booking, **attributes).call
  end

  def initialize(booking:, **attributes)
    @booking = booking
    @attributes = attributes
    @errors = nil
  end

  def call
    @booking.assign_attributes(booking_attributes.merge(expected_fee: calculate_expected_fee))

    if @booking.save
      self
    else
      @errors = @booking.errors
      self
    end
  end

  def success?
    @booking.present? && @booking.persisted? && @booking.errors.none?
  end

  private

  def account
    @booking.account
  end

  def booking_attributes
    @attributes.slice(
      :first_name, :last_name, :pet_name, :pet_type,
      :expected_fee, :time_span, :date_of_service
    )
  end
end
