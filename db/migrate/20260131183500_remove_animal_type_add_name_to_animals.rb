class RemoveAnimalTypeAddNameToAnimals < ActiveRecord::Migration[7.1]
  def change
    remove_column :animals, :animal_type, :integer
    add_column :animals, :name, :string
  end
end
