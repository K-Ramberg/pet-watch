class Account < ApplicationRecord
  has_many :animals, inverse_of: :account
  has_many :bookings, inverse_of: :account

  validates :name, presence: true
  validates :base_service_fee, presence: true, numericality: { greater_than: 0 }
end
