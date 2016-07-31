# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
  use Mix.Config

  config :pgexercises, Pgexercises.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: "exercises",
    username: "rain",
    hostname: "localhost"

  config :pgexercises, ecto_repos: [Pgexercises.Repo]
