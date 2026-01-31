# frozen_string_literal: true

class DeleteBookingService
  attr_reader :booking, :errors

  def self.call(booking:)
    new(booking: booking).call
  end

  def initialize(booking:)
    @booking = booking
    @errors = nil
  end

  def call
    @booking.destroy!
    self
  rescue ActiveRecord::RecordNotDestroyed => e
    @errors = e.record.errors
    self
  end

  def success?
    @booking.destroyed?
  end
end
