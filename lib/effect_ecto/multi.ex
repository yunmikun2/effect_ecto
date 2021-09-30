defmodule EffectEcto.Multi do
  @moduledoc false
  defstruct [:multi, :repo]
  def new(multi, repo), do: %__MODULE__{multi: multi, repo: repo}

  defimpl Effect.Executable do
    def execute(%{multi: multi, repo: repo}) do
      with {:error, failed_operation, failed_value, changes_so_far} <-
             repo.transaction(multi) do
        {:error,
         %{
           failed_operation: failed_operation,
           failed_value: failed_value,
           changes_so_far: changes_so_far
         }}
      end
    end
  end
end
