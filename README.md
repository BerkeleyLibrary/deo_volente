# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

#### Build:
```sh
docker compose build
```

#### Run:
```sh
docker compose up -d
```

**Note:** On first run, the database will not exist. To set up the database use `docker compose exec` to run the relevant
Rake task in the application container.

```sh
docker compose exec app rake db:setup assets:precompile
```

To Follow logs:
```sh
docker compose logs -f app
```

Open a bash shell into the app container:
```sh
docker compose exec -it app bash
```
* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
