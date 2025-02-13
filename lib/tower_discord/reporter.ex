defmodule TowerDiscord.Reporter do
  @moduledoc false
  @default_level :error

  require Logger

  def report_event(%Tower.Event{level: level} = event) do
    with true <- Tower.equal_or_greater_level?(level, level()),
         {:ok, url} <- fetch_webhook_url() do
      do_report_event(event, url)
    else
      false ->
        :ok

      {:error, :missing_webhook_url} ->
        Logger.warning("TowerDiscord added as a reporter, but webhook URL not configured.")
        :ok
    end
  end

  defp do_report_event(%Tower.Event{} = event, webhook_url) do
    Req.post!(webhook_url,
      json: %{
        content: build_message(event)
      }
    )

    :ok
  end

  defp fetch_webhook_url do
    case Application.get_env(:tower_discord, :webhook_url) do
      nil -> {:error, :missing_webhook_url}
      url -> {:ok, url}
    end
  end

  defp build_message(%Tower.Event{
         kind: kind,
         reason: exception,
         stacktrace: stacktrace
       }) do
    {module, function} = from(stacktrace)

    """
    Tower received an error of kind `#{kind}` from the function `#{function}` of the module `#{module}`.
    **Reason**:
    ```elixir
    #{inspect(exception)}
    ```
    **Stacktrace**:
    ```elixir
    #{inspect(stacktrace)}
    ```
    #tower_report #tower_type_#{kind}
    """
  end

  defp from(nil), do: {"Unknown", "unknown/0"}
  defp from([]), do: {"Unknown", "unknown/0"}
  defp from([head | _]), do: from(head)

  defp from({module, function, parameters, _}),
    do: {format_module(module), format_function(function, parameters)}

  defp format_module(module), do: Atom.to_string(module)
  defp format_function(function, n) when is_integer(n), do: Atom.to_string(function) <> "/#{n}"

  defp format_function(function, parameters) when is_list(parameters),
    do: Atom.to_string(function) <> "/" <> Integer.to_string(Enum.count(parameters))

  defp level(), do: Application.get_env(:tower_discord, :level, @default_level)
end
