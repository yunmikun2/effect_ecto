defmodule EffectEcto.InsertOrUpdate do
  @moduledoc false

  defstruct [:changeset, :repo, :opts]

  def new(changeset, repo, opts \\ []) do
    %__MODULE__{changeset: changeset, repo: repo, opts: opts}
  end

  defimpl Effect.Executable do
    def execute(%{changeset: changeset, repo: repo, opts: opts}) do
      repo.insert_or_update(changeset, opts)
    end
  end
end
