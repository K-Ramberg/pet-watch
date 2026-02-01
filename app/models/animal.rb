class Animal < ApplicationRecord
  belongs_to :account, inverse_of: :animals
  has_many :bookings, inverse_of: :animal

  validates :name, presence: true
  validates :additional_hour_fee, presence: true, numericality: { greater_than: 0 }
  
  before_destroy :check_if_animal_has_bookings

  private

  def check_if_animal_has_bookings
    if bookings.any?
      errors.add(:base, "Animal #{name} has bookings and cannot be destroyed")
      throw :abort
    end
  end
end
