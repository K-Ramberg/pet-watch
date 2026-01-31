class CreateAnimals < ActiveRecord::Migration[7.1]
  def change
    create_table :animals do |t|
      t.references :account, null: false, foreign_key: true, index: true
      t.integer :animal_type
      t.decimal :additional_hour_fee

      t.timestamps
    end
  end
end
