defmodule EffectEcto.Application do
  @moduledoc false

  use Application

  def start(_, _) do
    children = [EffectEcto.Repo]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
