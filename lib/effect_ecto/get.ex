defmodule EffectEcto.Get do
  @moduledoc false

  defstruct [:queryable, :id, :repo]

  def new(queryable, id, repo) do
    %__MODULE__{queryable: queryable, id: id, repo: repo}
  end

  defimpl Effect do
    def execute(%{queryable: queryable, id: id, repo: repo}) do
      case repo.get(queryable, id) do
        nil -> {:error, :not_found}
        r -> {:ok, r}
      end
    end
  end
end
