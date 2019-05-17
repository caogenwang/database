defmodule StoreManagerTest do
  use ExUnit.Case
  doctest StoreManager

  test "greets the world" do
    assert StoreManager.hello() == :world
  end
end
