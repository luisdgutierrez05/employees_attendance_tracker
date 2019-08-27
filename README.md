# Employees Attendance Tracker App


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
$ rspec spec
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
