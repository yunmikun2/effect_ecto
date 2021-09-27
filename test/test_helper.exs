{:ok, _} = EffectEcto.Application.start(nil, nil)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EffectEcto.Repo, :manual)
