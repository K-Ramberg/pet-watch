class Animal < ApplicationRecord
  belongs_to :account, inverse_of: :animals

  validates :name, presence: true
  validates :additional_hour_fee, presence: true, numericality: { greater_than: 0 }
end
