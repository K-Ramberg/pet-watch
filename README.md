# PetWatch

## Versions

- **Ruby** 3.3.7
- **Rails** 7.1.6

## Getting started

```bash
bundle install
bin/rails db:create db:migrate
bin/rails server

navigate to http://localhost:3000/accounts if not already redirected
```


## Making Pet Watch

This is a basic form/storage rails app to collect bookings for times to watch peoples pets at scheduled times and durations. I've grown entrenched into certain patterns and practices over the past few years working in a large monolith React on Rails application, so I approached this exercise with the intention of getting back to very basics of current rails app setup. This app was built with the current rails app scaffolding and built-in offerings as the main consideration to keep things within those patterns (for better or for worse).

### Omissions / Stretch Goals

In satisfying, at a basic level, the requested premis of the exercise instructions, there are a few typical application behaviors not included; most notably I have not built out a `Users` table with session permissions or a login flow. While certain gems like Devise are available for the heavy lifting, I didn't want to stretch too far past the basic form behaviors and over complicate the exercise. If was to take a second pass at elaborating this project, users/sessions would be my first goal to establish a true differentiation of an internal "admin" access and a "consumer" experience for generating and saving/tracking active + past bookings. The DB was constructed with these considerations in mind. 

As it stands, the curent use of the app involves an open account CRUD level to which access to Animals and Bookings are reliant in the basic UI. The UX might match the use case of an internal employee (with unsafe account level access) configuring supported animal types and recording bookings.

### Functionality

The current flow allows for the initial creation of an account, from which Animals and Bookings records can be generated. I've traded away some simplicity of pricing configuration for flexibility in adjusting supported service ranges, animals and their attached fees. The flexibility allows for a generalized pricing concern `Bookingable` to house the final booking fee logic. The front-end copies this logic to indicate expected fees while filling out the Booking form, updated with the built in Hotwire package (I'd have liked to more efficiently consolidated the logic but was limited by some unfamiliarity in the distance from my React comfort zone).

## Running tests

Run the full test suite:

```bash
bin/rails test
```

Run specific test types:

```bash
# Unit and service tests only (no browser)
bin/rails test test/models
bin/rails test test/services
bin/rails test test/controllers

# System (e2e) tests (requires Chrome)
bin/rails test test/system
```

Run a single test file:

```bash
bin/rails test test/models/booking_test.rb
bin/rails test test/services/create_booking_service_test.rb
bin/rails test test/controllers/bookings_controller_test.rb
bin/rails test test/system/bookings_test.rb
```

Run a single test by name:

```bash
bin/rails test test/models/booking_test.rb -n test_should_be_valid
```

System tests use Selenium with Chrome. Ensure Chrome and ChromeDriver are installed to run `test/system` tests.
