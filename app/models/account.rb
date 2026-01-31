class Account < ApplicationRecord
  has_many :animals
  has_many :bookings
end
