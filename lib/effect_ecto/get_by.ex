defmodule EffectEcto.GetBy do
  @moduledoc false

  defstruct [:queryable, :keys, :repo]

  def new(queryable, keys, repo) do
    %__MODULE__{queryable: queryable, keys: keys, repo: repo}
  end

  defimpl Effect.Executable do
    def execute(%{queryable: queryable, keys: keys, repo: repo}) do
      case repo.get_by(queryable, keys) do
        nil -> {:error, :not_found}
        r -> {:ok, r}
      end
    end
  end
end
