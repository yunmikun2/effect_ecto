defmodule EffectEcto.Delete do
  @moduledoc false

  defstruct [:deletable, :repo, :opts]

  def new(changeset_or_schema, repo, opts \\ []) do
    %__MODULE__{deletable: changeset_or_schema, repo: repo, opts: opts}
  end

  defimpl Effect.Executable do
    def execute(%{deletable: deletable, repo: repo, opts: opts}) do
      repo.delete(deletable, opts)
    end
  end
end
