# frozen_string_literal: true

module Bookingable
  extend ActiveSupport::Concern

  private

  def animal_additional_hour_fee
    if @attributes[:pet_type].blank?
      raise "Pet type is required"
    end

    animal = Animal.find_by(id: @attributes[:pet_type])
    if animal.blank?
      raise "Animal not found"
    end

    animal.additional_hour_fee
  end

  def calculate_expected_fee
    time_span = @attributes[:time_span].to_i
    account.base_service_fee + animal_additional_hour_fee * time_span
  end
end
