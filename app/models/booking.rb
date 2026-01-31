class Booking < ApplicationRecord
  belongs_to :account, inverse_of: :bookings

  validates :pet_type, presence: true
  validates :expected_fee, presence: true, numericality: { greater_than: 0 }
  validates :time_span, presence: true, numericality: { greater_than: 0 }
  validates :date_of_service, presence: true
end
