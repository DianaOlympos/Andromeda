use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :andromeda, Andromeda.Endpoint,
  secret_key_base: "IUk8fPtMoXPT/5hlkgJGkgUyJi8wnipPEs4G8VNqqvV0jrHLRjoXGvjFfHhd7rj"

config :andromeda,
  client_id: "",
  client_secret: "",
  redirect_uri: "",
  scope: "characterLocationRead characterNavigationWrite",
  user_agent: ""

config :guardian, Guardian,
        issuer: "Andromeda",
        ttl: { 20, :hours },
        verify_issuer: true, # optional
        secret_key: "PWRDjzEkJdw48BsgdNyzHGF6Atvb6HCtxLj95aDU",
        serializer: Andromeda.GuardianSerializer,
        verify_module: Andromeda.GuardianVerifier
