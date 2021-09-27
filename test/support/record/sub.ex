defmodule EffectEcto.Record.Sub do
  @moduledoc false

  use Ecto.Schema

  alias EffectEcto.Record

  schema "subs" do
    belongs_to(:record, Record)
    field(:y, :integer)
  end
end
