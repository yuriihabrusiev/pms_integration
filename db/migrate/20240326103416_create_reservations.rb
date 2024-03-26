class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.string :external_id, null: false # should be UUID
      t.datetime :checkin_at
      t.datetime :checkout_at
      t.integer :price
      t.string :guest_name
      t.integer :listing_id
      t.string :status

      t.timestamps

      t.index :external_id, unique: true
    end
  end
end
