class AddBookableTimeToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :minimum_bookable_time, :integer
    add_column :accounts, :maximum_bookable_time, :integer
  end
end
