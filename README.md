# Bibliogo
A software for library and lending books
You can create a book catalogue and keep track of the lent books

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

Currently, the only reliable tests are for the controllers models:

`docker compose exec -e RAILS_ENV=test -e PARALLEL_WORKERS=1 bibliogo rails test`

I'm still struggling for making the system tests work out

* Deployment instructions

* ...
