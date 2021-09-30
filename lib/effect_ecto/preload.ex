defmodule EffectEcto.Preload do
  @moduledoc false

  defstruct [:data, :preloads, :repo, :opts]

  def new(structs_or_struct_or_nil, preloads, repo, opts \\ []) do
    %__MODULE__{data: structs_or_struct_or_nil, preloads: preloads, repo: repo, opts: opts}
  end

  defimpl Effect.Executable do
    def execute(%{data: data, preloads: preloads, repo: repo, opts: opts}) do
      {:ok, repo.preload(data, preloads, opts)}
    end
  end
end
