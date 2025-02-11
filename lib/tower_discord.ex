defmodule TowerDiscord do
  @moduledoc """
  Simple post-to-Discord reporter for [Tower](`e:tower:Tower`) error handler.

  ## Example

      config :tower, :reporters, [TowerDiscord]
  """

  @behaviour Tower.Reporter

  @impl true
  defdelegate report_event(event), to: TowerDiscord.Reporter
end
