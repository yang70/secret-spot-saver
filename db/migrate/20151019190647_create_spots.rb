class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.decimal :lat
      t.decimal :lon
      t.string :water_type
      t.string :technique
      t.text :notes

      t.timestamps null: false
    end
  end
end
