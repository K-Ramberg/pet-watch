class Account < ApplicationRecord
  has_many :animals, inverse_of: :account
  has_many :bookings, inverse_of: :account

  validates :name, presence: true
  validates :base_service_fee, presence: true, numericality: { greater_than: 0 }
  validates :minimum_bookable_time, presence: true, numericality: { greater_than: 0 }
  validates :maximum_bookable_time, presence: true, numericality: { greater_than: 0 }
  validate :maximum_bookable_time_greater_than_or_equal_to_minimum

  private

  def maximum_bookable_time_greater_than_or_equal_to_minimum
    return if maximum_bookable_time.blank? || minimum_bookable_time.blank?

    if maximum_bookable_time < minimum_bookable_time
      errors.add(:maximum_bookable_time, "must be greater than or equal to minimum bookable time")
    end
  end
end
