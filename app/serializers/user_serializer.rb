# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  date_of_birth   :date
#  admin           :boolean          default(FALSE)
#  phone_number    :string
#  start_date      :date
#  end_date        :date
#  dni             :string
#  address         :string
#  position        :string
#  auth_token      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserSerializer < ActiveModel::Serializer # :nodoc:
  type :users

  attributes :id, :dni, :first_name, :last_name, :email, :date_of_birth, :admin,
             :address, :phone_number, :start_date, :end_date, :auth_token
end
