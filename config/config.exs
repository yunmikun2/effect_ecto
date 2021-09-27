import Config

config :effect_ecto, ecto_repos: [EffectEcto.Repo]

config :effect_ecto, EffectEcto.Repo,
  username: "postgres",
  password: "postgres",
  database: "effect_ecto_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
