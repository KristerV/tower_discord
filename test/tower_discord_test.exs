defmodule TowerDiscordTest do
  use ExUnit.Case
  doctest TowerDiscord

  test "greets the world" do
    assert TowerDiscord.hello() == :world
  end
end
