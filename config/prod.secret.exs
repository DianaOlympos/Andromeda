use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :andromeda, Andromeda.Endpoint,
  secret_key_base: "gf8P2S8sxoDj2hADfGbjM3bTc2aSWOJEB3mf6qxeoWFgnF8zWeEZMd4pDV7F6jTk"

config :andromeda,
  client_id: "a2d4cf2d2db343349168985de8242fcd",
  client_secret: "4IpgRTGj55QVQTHLOmjcKik2VSYNpdWb5IdJ0uHv",
  redirect_uri: "http://localhost:4000/auth/callback",
  scope: "characterLocationRead characterNavigationWrite",
  user_agent: "Andromeda Thomas Depierre"
