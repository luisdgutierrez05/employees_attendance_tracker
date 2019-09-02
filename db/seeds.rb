# frozen_string_literal: true

# default Administrator
User.create(
  first_name: 'Admin',
  last_name: 'RunaHR',
  email: 'admin@runahr.com',
  date_of_birth: 30.years.ago,
  position: 'manager',
  phone_number: '3001001000',
  address: 'Street 101',
  start_date: '01-02-2012',
  dni: '1720440100',
  password: 'Run@HR2019!',
  password_confirmation: 'Run@HR2019!',
  admin: true
)
