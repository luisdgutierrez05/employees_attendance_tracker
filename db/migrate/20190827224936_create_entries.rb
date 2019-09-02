class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries, id: :uuid do |t|
      t.datetime :checkin_at
      t.datetime :checkout_at
      t.references :user, foreign_key: true, type: :uuid
      t.text :observation

      t.timestamps
    end
  end
end
