class CreateYdates < ActiveRecord::Migration[8.1]
  def change
    create_table :ydates do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.integer :date
    end
  end
end
