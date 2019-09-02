
# Employees Attendance Tracker API


## Description
Simple web-based application that allows management of employees attendance.


## Requirements

* Rails 5.2.3
* Ruby 2.6.3
* PostgreSQL


## Getting started
To get started with the app, clone the repo and then install the needed gems:

```
$ cd /path/to/repos
$ git clone [employees_attendance_tracker](https://github.com/luisdgutierrez05/employees_attendance_tracker.git)
$ cd employees_attendance_tracker
$ bundle install
```

Next, setup the database:

```
$ cp config/database.yml.sample config/database.yml and add your Postgres settings.
$ rails db:setup
$ rails db:test:prepare
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rspec --exclude-pattern "spec/integration/**/*_spec.rb"
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

Swagger API Doc:
```
$ http://localhost:3000/api-docs/index.html
```


# Code Overview

## Dependencies
- [jwt](https://github.com/jwt/ruby-jwt) - For OAuth JSON Web Token (JWT) standard.
- [active_model_serializers](https://github.com/rails-api/active_model_serializers) - For JSON in an object-oriented and convention-driven manner.
- [will_paginate](https://github.com/mislav/will_paginate) - For implementing pagination.
- [pgcrypto](https://lab.io/articles/2017/04/13/uuids-rails-5-1/) - For generating primary keys as UUIDs on database.

## Roles and Permissions
  * Admin
    - Manage Employees.
    - Manage Entries.
    - Manage all reports.

  * Employee
    - Reports per day:
      - period (today).
      - period (yesterday).
      - specific date.

## Endpoints (23)

### Authenticate - Index
```
Action: POST
URL: {{protocol}}://{{server}}/auth/login
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {
  {
    "email": "admin@runahr.com",
    "password": "password"
  }
}
```
Response sample: [link](postman/response-samples/authenticate.json)

## Users:

### Index
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/users
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/users/index.json)



### Show
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/users/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/users/show.json)

### Create
```
Action: POST
URL: {{protocol}}://{{server}}/api/v1/users/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {
  "data": {
    "type": "users",
    "attributes": {
      "first_name": "Dev four",
      "last_name": "Runa",
      "dni": "32344654",
      "email": "devfour@runa.com",
      "phone_number": "4002003023",
      "date_of_birth": "09-02-1990",
      "position": "sales",
      "start_date": "01-01-2017",
      "password": "UOZ123456",
      "address": "Ave 80",
      "password_confirmation": "UOZ123456"
    }
  }
}
```
Response sample: [link](postman/response-samples/users/create.json)

### Update
```
Action: PUT
URL: {{protocol}}://{{server}}/api/v1/users/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {
  "data": {
    "type": "users",
    "attributes": {
      "end_date": "02-02-2016"
    }
  }
}
```
Response sample: [link](postman/response-samples/users/update.json)


### Destroy
```
Action: DELETE
URL: {{protocol}}://{{server}}/api/v1/users/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```

## Entries:

### Index
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/entries
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/entries/index.json)

### Show
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/entries/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/entries/show.json)

### Create
```
Action: POST
URL: {{protocol}}://{{server}}/api/v1/entries/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {
  "data": {
    "type": "entries",
    "attributes": {
      "checkin_at": "2019-09-01 09:02:01",
      "checkout_at": "2019-09-01 18:09:00",
      "user_id": "bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c",
      "observation": ""
    }
  }
}
```
Response sample: [link](postman/response-samples/entries/create.json)

### Update
```
Action: PUT
URL: {{protocol}}://{{server}}/api/v1/entries/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {
  "data": {
    "type": "entries",
    "attributes": {
    	"checkout_at": "2019-08-31 18:19:14",
      "observation": ""
    }
  }
}
```
Response sample: [link](postman/response-samples/entries/update.json)

### Destroy
```
Action: DELETE
URL: {{protocol}}://{{server}}/api/v1/entries/bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```

### Filter by user id
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/entries?user_id=bffb19f7-a70b-4ef2-9c1b-9e7411c2b26c
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/entries/filter_by_user_id.json)

### Filter by user email
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/entries?email=employee1@test.com
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/entries/filter_by_email.json)

## Reports:

### All entries
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/all_entries.json)

### Entries per day - period today
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=today
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_day/period_today.json)

### Entries per day - period yesterday
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=yesterday
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_day/period_yesterday.json)

### Entries per day - specific date
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?date=2019-08-29
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_day/specific_date.json)

### Entries per week - period this week
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=thisweek
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_week/period_thisweek.json)

### Entries per week - period last week
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=lastweek
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_week/period_lastweek.json)

### Entries per month - period this month
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=thismonth
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_month/period_thismonth.json)

### Entries per month - period last month
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=lastmonth
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_month/period_lastmonth.json)

### Entries per year - period this year
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=thisyear
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_year/period_thisyear.json)

### Entries per month - period last year
```
Action: GET
URL: {{protocol}}://{{server}}/api/v1/reports?period=lastyear
Headers: 'Content-Type': 'application/vnd.api+json'
Body params: {}
```
Response sample: [link](postman/response-samples/reports/per_year/period_lastyear.json)
