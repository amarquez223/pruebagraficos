class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.date :date
      t.string :description
      t.integer :type
      t.decimal :amount

      t.timestamps
    end
  end
end
