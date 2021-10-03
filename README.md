# EffectEcto

Elixir library that provides
[effects](https://github.com/yunmikun2/effect) for default
[ecto](https://github.com/elixir-ecto/ecto) operations.

## Usage

### Defined effects

It provides effects for every callback that exists in
[`Ecto.Repo`](https://hexdocs.pm/ecto/Ecto.Repo.html):

  - `EffectEcto.all(queryable, opts)`
  - `EffectEcto.delete(schema_or_changeset, opts)`
  - `EffectEcto.get(queryable, id, opts)`
  - `EffectEcto.get_by(queryable, keys, opts)`
  - `EffectEcto.insert(insertable, opts)`
  - `EffectEcto.insert_all(schema_or_source, entries_or_query, opts)`
  - `EffectEcto.insert_or_update(changeset, opts)`
  - `EffectEcto.one(queryable, opts)`
  - `EffectEcto.preload(data, preloads, opts)`
  - `EffectEcto.transaction(effect, opts)`
  - `EffectEcto.update(changeset, opts)`
  - `EffectEcto.update_all(queryable, updates, opts)`

The most notable among them is `EffectEcto.Transaction` that allows
us to wrap any effect into a database migration.

```elixir
iex(1)> alias Effect.Pipe
iex(2)> alias MyApp.Repo
iex(3)> Pipe.new()
...(3)> |> Pipe.then(:insert, fn _ -> EffectEcto.insert(%Data{x: 1}) end)
...(3)> |> Pipe.then(:fail, fn _ -> Effect.fail("oops") end)
...(3)> |> EffectEcto.transaction()
...(3)> |> Effect.execute()
{:error, %{fail: "oops"}} # Rollback will be called and nothing will be inserted.
```

You also have a way to wrap `Ecto.Multi` struct:

```elixir
iex(1)> alias Ecto.Multi
iex(2)> MyApp.Repo
iex(3)> multi = Multi.insert(Multi.new(), :insert, %Data{x: 1})
iex(4)> multi
...(4)> |> EffectEcto.multi()
...(4)> |> Effect.execute()
{:ok, %{insert: %Data{x: 1}}}
```

### Protocol implementation

When `use`ing `EffectEcto`, you generate implementation for
`Effect.Executable` with the repo module you are using it.

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, # ...
  use EffectEcto
end

# Now this code may be executed:
%Data{x: 1} |> EffectEcto.insert() |> Effect.execute()
```

## Installation

```elixir
def deps do
  [
    {:effect_ecto, git: "https://github.com/yunmikun2/effect_ecto", tag: "v0.2.0"}
  ]
end
```
