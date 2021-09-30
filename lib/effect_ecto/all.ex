defmodule EffectEcto.All do
  @moduledoc false

  defstruct [:repo, :queryable]

  def new(queryable, repo) do
    %__MODULE__{queryable: queryable, repo: repo}
  end

  defimpl Effect.Executable do
    def execute(%{queryable: queryable, repo: repo}) do
      {:ok, repo.all(queryable)}
    end
  end
end
