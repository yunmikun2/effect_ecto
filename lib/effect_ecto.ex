defmodule EffectEcto do
  @moduledoc """
  Provides `Effect` implementation for `Ecto` operations.
  """

  defmodule All do
    @moduledoc """
    Wraps fetchig everything from a queryable.

    See `c:Ecto.Repo.all/2` for details.

    ## Fields

      - `queryable` - `Ecto.Queryable`;
      - `opts`.
    """

    defstruct [:queryable, :opts]
  end

  def all(queryable, opts \\ []) do
    %All{queryable: queryable, opts: opts}
  end

  defmodule ApplyChanges do
    @moduledoc """
    Converts a changeset into a struct with applied changes.

    See `Ecto.Changeset.apply_action/2` for more details.

    > **Note:** We don't need to access this effect from the
    > `interpreter`, so we implement `Effect.Interpretable` for this
    > struct and access only the result of the effect when interpreting.
    """

    alias Ecto.Changeset
    alias Effect.{Executable, Interpretable}

    @derive [Executable]
    defstruct [:changeset]

    defimpl Interpretable do
      def interpret(%{changeset: changeset}, _interpreter) do
        Changeset.apply_action(changeset, :insert)
      end
    end
  end

  def apply_changes(changeset) do
    %ApplyChanges{changeset: changeset}
  end

  defmodule Delete do
    @moduledoc """
    Delete changeset or schema.

    See `c:Ecto.Repo.delete/2` for details.

    ## Fields

      - `deletable`
      - `opts`
    """

    defstruct [:deletable, :opts]
  end

  def delete(changeset_or_schema, opts \\ []) do
    %Delete{deletable: changeset_or_schema, opts: opts}
  end

  defmodule Get do
    @moduledoc """
    Get by id.

    See `c:Ecto.Repo.get/3` for more details.

    ## Fields

      - `queryable`
      - `id`
      - `opts`
    """

    defstruct [:queryable, :id, :opts]
  end

  def get(queryable, id, opts \\ []) do
    %Get{queryable: queryable, id: id, opts: opts}
  end

  defmodule GetBy do
    @moduledoc """
    Get by fields.

    See `c:Ecto.Repo.get_by/3` for more details.

    ## Fields

      - `queryable`
      - `keys`
      - `opts`
    """

    defstruct [:queryable, :keys, :opts]
  end

  def get_by(queryable, keys, opts \\ []) do
    %GetBy{queryable: queryable, keys: keys, opts: opts}
  end

  defmodule Insert do
    @moduledoc """
    Inserts a changeset or a schema.

    See `c:Ecto.Repo.insert/2` for details.

    ## Fields

      - `insertable`
      - `opts`
    """

    defstruct [:insertable, :opts]
  end

  def insert(schema_or_changeset, opts \\ []) do
    %Insert{insertable: schema_or_changeset, opts: opts}
  end

  defmodule InsertAll do
    @moduledoc """
    Insert all the rows.

    See `c:Ecto.Repo.insert_all/3` for details.

    ## Fields

      - `source`
      - `data`
      - `opts`
    """

    defstruct [:source, :data, :opts]
  end

  def insert_all(source, data, opts \\ []) do
    %InsertAll{source: source, data: data, opts: opts}
  end

  defmodule InsertOrUpdate do
    @moduledoc """
    Implements UPSERT behaviour.

    See `c:Ecto.Repo.insert_or_update/2` for details.

    # Fields

      - `changeset`
      - `opts`
    """

    defstruct [:changeset, :opts]
  end

  def insert_or_update(changeset, opts \\ []) do
    %InsertOrUpdate{changeset: changeset, opts: opts}
  end

  defmodule Multi do
    @moduledoc """
    Wraps `Ecto.Multi` struct into a transaction effect.

    # Fields

      - `multi`
    """

    defstruct [:multi]
  end

  def multi(multi) do
    %Multi{multi: multi}
  end

  defmodule One do
    @moduledoc """
    Fetches one record for the database.

    See `c:Ecto.Repo.one/2` for details.

    # Fields

      - `query`
      - `opts`
    """

    defstruct [:query, :opts]
  end

  def one(query, opts \\ []) do
    %One{query: query, opts: opts}
  end

  defmodule Preload do
    @moduledoc """
    Wraps preloads into an effect.

    See `c:Ecto.Repo.preload/3` for details.

    # Fields

      - `data`
      - `preloads`
      - `opts`
    """

    defstruct [:data, :preloads, :opts]
  end

  def preload(structs_or_struct_or_nil, preloads, opts \\ []) do
    %Preload{data: structs_or_struct_or_nil, preloads: preloads, opts: opts}
  end

  defmodule Transaction do
    @moduledoc """
    Wraps an effect in a database transaction.

    See `c:Ecto.Repo.transaction/2` for details.

    > **Note:** When called via `Effect.Interpretable`, it's not wrapped
    > in a transaction and not even handled (you just interpret the
    > underlying effect).
    """

    defstruct [:effect, :opts]

    defimpl Effect.Interpretable do
      def interpret(%{effect: effect}, interpreter) do
        interpreter.(effect)
      end
    end
  end

  def transaction(effect, opts \\ []) do
    %Transaction{effect: effect, opts: opts}
  end

  defmodule Update do
    @moduledoc """
    Apply updates to a changeset.

    See `c:Ecto.Repo.update/2` for details.

    # Fields

      - `changeset`
      - `opts`
    """

    defstruct [:changeset, :opts]
  end

  def update(changeset, opts \\ []) do
    %Update{changeset: changeset, opts: opts}
  end

  defmodule UpdateAll do
    @moduledoc """
    Run update queries.

    See `c:Ecto.Repo.update_all/3` for details.

    # Fields

      - `queryable`
      - `updates`
      - `opts`
    """

    defstruct [:queryable, :updates, :opts]
  end

  def update_all(queryable, updates, opts \\ []) do
    %UpdateAll{queryable: queryable, updates: updates, opts: opts}
  end

  @doc """
  Create implementation for this repo.
  """
  defmacro __using__(_) do
    repo = __CALLER__.module

    quote do
      alias EffectEcto.{
        All,
        Delete,
        Get,
        GetBy,
        Insert,
        InsertAll,
        InsertOrUpdate,
        One,
        Preload,
        Transaction,
        Update,
        UpdateAll
      }

      defimpl Effect.Executable, for: All do
        def execute(%{queryable: queryable, opts: opts}) do
          {:ok, unquote(repo).all(queryable, opts)}
        end
      end

      defimpl Effect.Executable, for: Delete do
        def execute(%{deletable: deletable, opts: opts}) do
          unquote(repo).delete(deletable, opts)
        end
      end

      defimpl Effect.Executable, for: Get do
        def execute(%{queryable: queryable, id: id, opts: opts}) do
          case unquote(repo).get(queryable, id, opts) do
            nil -> {:error, :not_found}
            r -> {:ok, r}
          end
        end
      end

      defimpl Effect.Executable, for: GetBy do
        def execute(%{queryable: queryable, keys: keys, opts: opts}) do
          case unquote(repo).get_by(queryable, keys, opts) do
            nil -> {:error, :not_found}
            r -> {:ok, r}
          end
        end
      end

      defimpl Effect.Executable, for: Insert do
        def execute(%{insertable: insertable, opts: opts}) do
          unquote(repo).insert(insertable, opts)
        end
      end

      defimpl Effect.Executable, for: InsertAll do
        def execute(%{source: source, data: data, opts: opts}) do
          {:ok, unquote(repo).insert_all(source, data, opts)}
        end
      end

      defimpl Effect.Executable, for: InsertOrUpdate do
        def execute(%{changeset: changeset, opts: opts}) do
          unquote(repo).insert_or_update(changeset, opts)
        end
      end

      defimpl Effect.Executable, for: Multi do
        def execute(%{multi: multi}) do
          with {:error, failed_operation, failed_value, changes_so_far} <-
                 unquote(repo).transaction(multi) do
            {:error,
             %{
               failed_operation: failed_operation,
               failed_value: failed_value,
               changes_so_far: changes_so_far
             }}
          end
        end
      end

      defimpl Effect.Executable, for: One do
        def execute(%{query: query, opts: opts}) do
          {:ok, unquote(repo).one(query, opts)}
        end
      end

      defimpl Effect.Executable, for: Preload do
        def execute(%{data: data, preloads: preloads, opts: opts}) do
          {:ok, unquote(repo).preload(data, preloads, opts)}
        end
      end

      defimpl Effect.Executable, for: Transaction do
        def execute(%{effect: effect, opts: opts}) do
          fun = fn ->
            case Effect.execute(effect) do
              {:ok, result} -> result
              {:error, error} -> unquote(repo).rollback(error)
            end
          end

          unquote(repo).transaction(fun, opts)
        end
      end

      defimpl Effect.Executable, for: Update do
        def execute(%{changeset: changeset, opts: opts}) do
          unquote(repo).update(changeset, opts)
        end
      end

      defimpl Effect.Executable, for: UpdateAll do
        def execute(%{queryable: queryable, updates: updates, opts: opts}) do
          {:ok, unquote(repo).update_all(queryable, updates, opts)}
        end
      end
    end
  end
end
