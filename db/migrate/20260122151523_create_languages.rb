class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.timestamps
      t.string :name
      t.text :details
      t.string :maxlexeid
    end
  end
end
