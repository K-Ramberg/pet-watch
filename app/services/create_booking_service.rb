# frozen_string_literal: true

class CreateBookingService
  include Bookingable

  attr_reader :booking, :errors

  def self.call(account:, **attributes)
    new(account: account, **attributes).call
  end

  def initialize(account:, **attributes)
    @account = account
    @attributes = attributes
    @booking = nil
    @errors = nil
  end

  def call
    @booking = Booking.new(booking_attributes.merge(expected_fee: calculate_expected_fee))

    if @booking.save
      self
    else
      @errors = @booking.errors
      self
    end
  end

  def success?
    @booking.present? && @booking.persisted?
  end

  private

  def account
    @account
  end

  def booking_attributes
    @attributes.slice(
      :first_name, :last_name, :pet_name, :pet_type,
      :expected_fee, :time_span, :date_of_service
    ).merge(account: @account)
  end
end
