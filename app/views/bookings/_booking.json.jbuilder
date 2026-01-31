json.extract! booking, :id, :first_name, :last_name, :pet_name, :pet_type, :expected_fee, :time_span, :date_of_service, :created_at, :updated_at
json.url booking_url(booking, format: :json)
