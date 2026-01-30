class CreateNames < ActiveRecord::Migration[8.1]
  def change
    create_table :names do |t|
      t.timestamps
      t.references :dialect, null: false, foreign_key: true
      t.string :value
    end
  end
end
