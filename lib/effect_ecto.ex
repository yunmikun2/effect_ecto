defmodule EffectEcto do
  @moduledoc false

  defmacro __using__(_) do
    repo = __CALLER__.module

    quote do
      defmodule Effects do
        alias EffectEcto.{
          All,
          Delete,
          Get,
          GetBy,
          Insert,
          InsertAll,
          One,
          Preload,
          Transaction,
          Update,
          UpdateAll
        }

        def all(queryable) do
          All.new(queryable, unquote(repo))
        end

        def delete(schema_or_changeset, opts \\ []) do
          Delete.new(schema_or_changeset, unquote(repo), opts)
        end

        def get(queryable, id) do
          Get.new(queryable, id, unquote(repo))
        end

        def get_by(queryable, keys) do
          GetBy.new(queryable, keys, unquote(repo))
        end

        def insert(insertable, opts \\ []) do
          Insert.new(insertable, unquote(repo), opts)
        end

        def insert_all(schema_or_source, entries_or_query, opts \\ []) do
          InsertAll.new(schema_or_source, entries_or_query, unquote(repo), opts)
        end

        def insert_or_update(changeset, opts \\ []) do
          InsertOrUpdate.new(changeset, unquote(repo), opts)
        end

        def one(queryable) do
          One.new(queryable, unquote(repo))
        end

        def preload(data, preloads, opts \\ []) do
          Preload.new(data, preloads, repo, opts)
        end

        def transaction(effect) do
          Transaction.new(effect, unquote(repo))
        end

        def update(changeset, opts \\ []) do
          Update.new(changeset, unquote(repo), opts)
        end

        def update_all(queryable, updates, opts \\ []) do
          UpdateAll.new(queryable, updates, unquote(repo), opts)
        end
      end
    end
  end
end
