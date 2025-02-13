defmodule TowerDiscordTest do
  use ExUnit.Case
  doctest TowerDiscord

  import ExUnit.CaptureLog, only: [capture_log: 1]

  setup do
    lasso = Lasso.open()

    Application.put_env(:tower, :reporters, [TowerDiscord])
    Application.put_env(:tower_discord, :webhook_url, "http://localhost:#{lasso.port}/")

    {:ok, lasso: lasso}
  end

  test "reports exception", %{lasso: lasso} do
    # ref message synchronization trick copied from
    # https://github.com/PSPDFKit-labs/bypass/issues/112
    parent = self()
    ref = make_ref()

    Lasso.expect_once(lasso, "POST", "/", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)

      assert(
        %{
          "content" => content
        } = Jason.decode!(body)
      )

      assert String.starts_with?(content, "Tower received an error")
      assert String.match?(content, ~r/ArithmeticError/)
      assert String.match?(content, ~r/bad argument/)

      send(parent, {ref, :sent})

      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.resp(200, Jason.encode!(%{"ok" => true}))
    end)

    capture_log(fn ->
      Task.start(fn ->
        1 / 0
      end)
    end)

    assert_receive({^ref, :sent}, 500)
  end
end
