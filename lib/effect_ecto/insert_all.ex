defmodule EffectEcto.InsertAll do
  @moduledoc false

  defstruct [:source, :data, :repo, :opts]

  def new(source, data, repo, opts \\ []) do
    %__MODULE__{source: source, data: data, repo: repo, opts: opts}
  end

  defimpl Effect.Executable do
    def execute(%{source: source, data: data, repo: repo, opts: opts}) do
      {:ok, repo.insert_all(source, data, opts)}
    end
  end
end
