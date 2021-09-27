# EffectEcto

Elixir library that provides
[effects](https://github.com/yunmikun2/effect) for default
[ecto](https://github.com/elixir-ecto/ecto) operations.

> **Note:** It may be not the best way to use ecto, but it's
> definitelly usefull for migrating existing code base to effects.

## Usage

### Defined effects

It provides effects for every callback that exists in
[`Ecto.Repo`](https://hexdocs.pm/ecto/Ecto.Repo.html):

  - `EffectEcto.All.new(queryable, repo)`
  - `EffectEcto.Delete.new(schema_or_changeset, repo, opts)`
  - `EffectEcto.Get.new(queryable, id, repo)`
  - `EffectEcto.GetBy.new(queryable, keys, repo)`
  - `EffectEcto.Insert.new(insertable, repo, opts)`
  - `EffectEcto.InsertAll.new(schema_or_source, entries_or_query, repo, opts)`
  - `EffectEcto.InsertOrUpdate.new(changeset, repo, opts)`
  - `EffectEcto.One.new(queryable, repo)`
  - `EffectEcto.Preload.new(data, preloads, repo, opts)`
  - `EffectEcto.Transaction.new(effect, repo)`
  - `EffectEcto.Update.new(changeset, repo, opts)`
  - `EffectEcto.UpdateAll.new(queryable, updates, repo, opts)`

The most notable among them is `EffectEcto.Transaction` that allows
us to wrap any effect into a database migration.

```elixir
iex(1)> alias Effect.{Fail, Pipe}
iex(2)> alias EffectEcto.{Insert, Transaction}
iex(3)> alias MyApp.Repo
iex(4)> Pipe.new()
...(4)> |> Pipe.then(:insert, fn _ -> Insert.new(%Data{x: 1}, Repo) end)
...(4)> |> Pipe.then(:fail, fn _ -> Fail.new("oops") end)
...(4)> |> Effect.execute()
{:error, %{fail: "oops"}} # Rollback will be called and nothing will be inserted.
```

### Repo helpers

Supplying `Repo` on each call may be not so convinient, so you can
`use EffectEcto` to generate helper functions that don't require
`repo` argument:

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, # ...
  use EffectEcto
end

alias MyApp.Repo.Effects
Effects.insert(%Data{x: 1}) # => %EffectEcto.Insert{} with MyApp.Repo
```

## Installation

```elixir
def deps do
  [
    {:effect_ecto, git: "https://github.com/yunmikun2/effect_ecto"}
  ]
end
```
