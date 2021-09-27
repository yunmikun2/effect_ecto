defmodule EffectEcto.Insert do
  @moduledoc false

  defstruct [:insertable, :repo, :opts]

  def new(changeset_or_schema, repo, opts \\ []) do
    %__MODULE__{insertable: changeset_or_schema, repo: repo, opts: opts}
  end

  defimpl Effect do
    def execute(%{insertable: insertable, repo: repo, opts: opts}) do
      repo.insert(insertable, opts)
    end
  end
end
