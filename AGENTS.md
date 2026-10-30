# bibliogo

Catalogo e prestiti per una piccola biblioteca. Rails + MongoDB, nessun ActiveRecord.

## Stack

- Ruby 2.7 (`.ruby-version` 2.7.2; Gemfile `~> 2.7.3`, allineato all'immagine Docker di base), Rails 6.0.3
- Database: MongoDB via Mongoid 7; paginazione con kaminari-mongoid
- Frontend: webpacker 4 + yarn, Bootstrap 4, jQuery, turbolinks
- i18n: default `:it`, traduzioni in `lib/locale/*.yml` caricate da `config/initializers/locale.rb`

## Comandi

- Avvio: `docker compose up` (mongo, mongo-express su 8081, app su 3000).
  Serve un file `.env` (non nel repo) con `MONGODB_ROOT_PASSWORD`, `MONGODB_DATABASE`, `MONGODB_HOST`.
  `entrypoint.sh` lancia `bundle update`, `rake db:mongoid:create_indexes`, `yarn install/upgrade` e `rails s`.
- Test affidabili (solo models/controllers):
  `docker compose exec -e RAILS_ENV=test -e PARALLEL_WORKERS=1 bibliogo rails test`
- E2e/system test: stack dedicato con Chrome remoto via Selenium
  (`docker-compose.e2e.yml`, immagine `Dockerfile.e2e` con `RAILS_ENV=test` e pack webpacker compilati):
  `docker compose -f docker-compose.e2e.yml build`
  `docker compose -f docker-compose.e2e.yml run --rm bibliogo sh -c "rake db:mongoid:create_indexes && rails test:system"`
  Il driver remoto si attiva con `SELENIUM_REMOTE_URL`; senza la variabile Capybara usa headless Chrome locale.

## Gotcha

- **System test**: girano nello stack e2e con Chrome remoto (vedi Comandi); usano factory_bot (`test/factories.rb`), non fixture — il progetto è su Mongoid e le fixture di Rails non esistono qui.
- **Niente migrazioni/schema**: i documenti sono definiti nei model; gli indici si creano con `rake db:mongoid:create_indexes` (il testo search `$text` e l'indice univoco su `code` servono anche ai test).
- **`Book#code` è assegnato dal server** in `create` tramite la collection `Sequence` (`Book.next_code`); non è in `book_params`, non passarlo dal form.
- **`authors` è un Array** sul documento, ma il form invia una stringa virgole-separate che i controller splittano a mano (create/update/clone di `BooksController`).
- **Autenticazione**: sessioni + bcrypt. `ApplicationController#logged_in?` restituisce true se non esiste ancora nessun utente (bootstrap del primo utente). `BooksController` protegge solo le azioni di scrittura, `LoansController` tutte.
- **`Loan` ha attributi dinamici** (`Mongoid::Attributes::Dynamic`): campi non dichiarati vengono salvati senza errori.
- Ricerca libera su `Book` via indice text `$**` con `default_language: "it"`.
- In development la paginazione è forzata a 2 elementi per pagina (`paginates_per`).

## Workflow

- Branch di default: `main`. CI (`.github/workflows/docker-image.yml`) pubblica `alkcxy/bibliogo:latest` su Docker Hub a ogni push su `main`.
- Sempre feature branch + PR verso `main`, mai commit diretti su `main`.
