defmodule EffectEcto.Record do
  @moduledoc false

  use Ecto.Schema

  schema "records" do
    field(:x, :integer)
    has_many(:subs, __MODULE__.Sub)
  end
end
