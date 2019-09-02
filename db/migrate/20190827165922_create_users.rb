# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :password_digest, null: false
      t.date :date_of_birth
      t.boolean :admin, default: false
      t.string :phone_number
      t.date :start_date
      t.date :end_date
      t.string :dni
      t.string :address
      t.string :position
      t.string :auth_token

      t.timestamps
    end
  end
end
