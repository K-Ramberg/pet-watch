class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :account, null: false, foreign_key: true, index: true
      t.string :first_name
      t.string :last_name
      t.string :pet_name
      t.integer :pet_type
      t.decimal :expected_fee
      t.integer :time_span
      t.datetime :date_of_service

      t.timestamps
    end
  end
end
