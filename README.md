# Bibliogo
A software for library and lending books

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

Currently, the only reliable tests are for the controllers and the loan model:

`docker compose exec -e RAILS_ENV=test -e PARALLEL_WORKERS=1 bibliogo rails test test/controllers`

`docker compose exec -e RAILS_ENV=test -e PARALLEL_WORKERS=1 bibliogo rails test test/models`

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
