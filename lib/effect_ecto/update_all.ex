defmodule EffectEcto.UpdateAll do
  @moduledoc false

  defstruct [:queryable, :updates, :repo, :opts]

  def new(queryable, updates, repo, opts \\ []) do
    %__MODULE__{queryable: queryable, updates: updates, repo: repo, opts: opts}
  end

  defimpl Effect.Executable do
    def execute(%{queryable: queryable, updates: updates, repo: repo, opts: opts}) do
      {:ok, repo.update_all(queryable, updates, opts)}
    end
  end
end
