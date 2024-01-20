import Config
config :genstage_demo_2023, ecto_repos: [GenstageDemo2023.Repo],
log: false

config :genstage_demo_2023, GenstageDemo2023.Repo,
  database: "genstage_demo_2023_repo",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :logger,
  level: :info

