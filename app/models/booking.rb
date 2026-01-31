class Booking < ApplicationRecord
  belongs_to :account, inverse_of: :bookings

  validates :pet_type, presence: true
  validates :expected_fee, presence: true, numericality: { greater_than: 0 }
  validate :time_span_within_account_bookable_range
  validates :date_of_service, presence: true
  validate :date_of_service_does_not_conflict_with_other_bookings

  private

  def time_span_within_account_bookable_range
    return if time_span.blank? || account.blank?

    min = account.minimum_bookable_time
    max = account.maximum_bookable_time
    return if min.blank? || max.blank?

    allowed_max = max - min
    if time_span > allowed_max
      errors.add(:time_span, "must be less than or equal to the account's bookable time range (#{allowed_max})")
    end
  end

  def date_of_service_does_not_conflict_with_other_bookings
    return if date_of_service.blank? || time_span.blank? || account_id.blank?

    start_time = date_of_service
    end_time = date_of_service + time_span.minutes

    conflicting = account.bookings.where.not(id: id).any? do |other|
      other_start = other.date_of_service
      other_end = other.date_of_service + other.time_span.minutes
      start_time < other_end && other_start < end_time
    end

    if conflicting
      errors.add(:date_of_service, "cannot overlap with another booking for this account")
    end
  end
end
