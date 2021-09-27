defmodule EffectEcto.One do
  @moduledoc false

  defstruct [:query, :repo]

  def new(query, repo) do
    %__MODULE__{query: query, repo: repo}
  end

  defimpl Effect do
    def execute(%{query: query, repo: repo}) do
      {:ok, repo.one(query)}
    end
  end
end
