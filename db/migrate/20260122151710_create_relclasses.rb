class CreateRelclasses < ActiveRecord::Migration[8.1]
  def change
    create_table :relclasses do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.string :kind
      t.string :topbottom
      t.string :bottomtop
    end
  end
end
