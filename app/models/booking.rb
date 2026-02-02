class Booking < ApplicationRecord
  belongs_to :account, inverse_of: :bookings
  belongs_to :animal, class_name: "Animal", foreign_key: :pet_type, optional: true
  
  before_create :date_of_service_is_in_future

  validates :pet_type, presence: true
  validates :expected_fee, presence: true, numericality: { greater_than: 0 }
  validate :time_span_within_account_bookable_range
  validates :date_of_service, presence: true
  validate :date_of_service_does_not_conflict_with_other_bookings

  def booking_past_due_date?
    date_of_service < Time.current
  end

  private

  def date_of_service_is_in_future
    return if date_of_service.blank?

    if date_of_service < Time.current
      errors.add(:date_of_service, "booking must be scheduled for a future date")
      throw :abort
    end
  end

  def time_span_within_account_bookable_range
    return if time_span.blank? || account.blank?

    min = account.minimum_bookable_time
    max = account.maximum_bookable_time
    return if min.blank? || max.blank?

    if time_span > max || time_span < min
      errors.add(:time_span, "must be greater than or equal to the account's minimum bookable time (#{min}) and less than or equal to the account's maximum bookable time (#{max})")
    end
  end

  def date_of_service_does_not_conflict_with_other_bookings
    return if date_of_service.blank? || time_span.blank? || account_id.blank?

    start_time = date_of_service
    end_time = date_of_service + time_span.hours

    conflicting = account.bookings.where.not(id: id).any? do |other|
      other_start = other.date_of_service
      other_end = other.date_of_service + other.time_span.hours
      start_time < other_end && other_start < end_time
    end

    if conflicting
      errors.add(:date_of_service, "cannot overlap with another booking for this account")
    end
  end
end
