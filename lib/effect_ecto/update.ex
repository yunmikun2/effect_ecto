defmodule EffectEcto.Update do
  @moduledoc false

  defstruct [:changeset, :repo, :opts]

  def new(changeset, repo, opts \\ []) do
    %__MODULE__{changeset: changeset, repo: repo, opts: opts}
  end

  defimpl Effect do
    def execute(%{changeset: changeset, repo: repo, opts: opts}) do
      repo.update(changeset, opts)
    end
  end
end
