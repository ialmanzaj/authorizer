defmodule AccountTest do
  use ExUnit.Case

  test "create an empty account" do
    assert Account.new() == %Account{active_card: nil, available_limit: nil}
  end

  test "create an normal account" do
    assert Account.new(true, 100) == %Account{active_card: true, available_limit: 100}
  end
end
