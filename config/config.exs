import Config

config :cat_facts,
  api_url: "https://cat-fact.herokuapp.com"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]
