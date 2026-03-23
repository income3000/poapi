class CreateOfficers < ActiveRecord::Migration[8.0]
  def change
    create_table :officers do |t|
      t.string :name
      t.string :bn
      t.text :incident

      t.timestamps
    end
  end
end
