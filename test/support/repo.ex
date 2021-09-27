defmodule EffectEcto.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :effect_ecto,
    adapter: Ecto.Adapters.Postgres
end
