defmodule CatFactsTest do
  use ExUnit.Case
  doctest CatFacts

  test "greets the world" do
    assert CatFacts.hello() == :world
  end
end
