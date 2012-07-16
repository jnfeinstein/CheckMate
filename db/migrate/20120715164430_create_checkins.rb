class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.string :first
      t.string :last
      t.string :conf
      t.string :time
      t.references :user

      t.timestamps
    end
    add_index :checkins, :user_id
  end
end
