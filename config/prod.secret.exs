use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :andromeda, Andromeda.Endpoint,
  secret_key_base: "IUk8fPtMoXPT/5hlkgJGkgUyJi8wnipPEs4G8VNqqvV0jrHLRjoXGvjFfHhd7rj"

config :andromeda,
  client_id: "0ae0d33077f64f5684d4b4f98aa9b103",
  client_secret: "5POw9ETaNqm7ZgdgNEJILGScR0pIUbHXL1AyVFf1",
  redirect_uri: "http://localhost:4000/auth/callback",
  scope: "characterLocationRead characterNavigationWrite",
  user_agent: "Andromeda Thomas Depierre"
