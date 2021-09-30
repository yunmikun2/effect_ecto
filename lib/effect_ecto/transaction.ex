defmodule EffectEcto.Transaction do
  @moduledoc false

  defstruct [:effect, :repo]

  def new(effect, repo), do: %__MODULE__{effect: effect, repo: repo}

  defimpl Effect.Executable do
    def execute(%{effect: effect, repo: repo}) do
      repo.transaction(fn ->
        case Effect.execute(effect) do
          {:ok, result} -> result
          {:error, error} -> repo.rollback(error)
        end
      end)
    end
  end

  defimpl Effect.Interpretable do
    def interpret(%{effect: effect, repo: _repo}, interpreter) do
      interpreter.(effect)
    end
  end
end
