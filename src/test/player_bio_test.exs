defmodule PlayerBioTest do
  use ExUnit.Case
  doctest PlayerBio

  test "greets the world" do
    assert PlayerBio.hello() == :world
  end
end
