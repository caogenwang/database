defmodule StoreSystemTest do
  use ExUnit.Case
  doctest StoreSystem

  test "greets the world" do
    assert StoreSystem.hello() == :world
  end
end
