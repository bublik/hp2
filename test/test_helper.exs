ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Ph2.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Ph2.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Ph2.Repo)

