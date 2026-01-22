class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.date :date
      t.string :kind
      t.string :summary
      t.text :details
    end
  end
end
