ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Andromeda.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Andromeda.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Andromeda.Repo)

