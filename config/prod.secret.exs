use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :andromeda, Andromeda.Endpoint,
  secret_key_base: "gf8P2S8sxoDj2hADfGbjM3bTc2aSWOJEB3mf6qxeoWFgnF8zWeEZMd4pDV7F6jTk"

config :andromeda,
  client_id: "",
  client_secret: "",
  redirect_uri: "",
  scope: "characterLocationRead characterNavigationWrite",
  user_agent: ""
