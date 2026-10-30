# Bibliogo

A software for library and lending books
You can create a book catalogue and keep track of the lent books

# Som useful query
Count all loans group by Place:
`db.loans.aggregate(   [{ $group: {_id: "$place", totalAmount: { $sum: 1 }}}])`

---

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

Unit and controller tests:

`docker compose exec -e RAILS_ENV=test -e PARALLEL_WORKERS=1 bibliogo rails test`

System (e2e) tests run in their own stack, with a remote Chrome driven by Selenium:

```
docker compose -f docker-compose.e2e.yml build
docker compose -f docker-compose.e2e.yml run --rm bibliogo sh -c "rake db:mongoid:create_indexes && rails test:system"
```

To run everything in the e2e stack (unit + system):

`docker compose -f docker-compose.e2e.yml run --rm bibliogo sh -c "rake db:mongoid:create_indexes && rails test"`

* Deployment instructions

* ...
