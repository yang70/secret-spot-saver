class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.integer :lat
      t.integer :lon
      t.string :water_type
      t.string :technique
      t.text :notes

      t.timestamps null: false
    end
  end
end
