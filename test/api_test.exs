defmodule ApiTest do
  use ExUnit.Case
  doctest Api

  test "create an empty account" do
    assert Account.new() == %Account{active_card: nil, available_limit: nil}
  end

  test "create an normal account" do
    assert Account.new(true, 100) == %Account{active_card: true, available_limit: 100}
  end

  test "decrement an account" do
    account = Account.new(true, 50)
    assert Account.decrement(account, 50) == %Account{active_card: true, available_limit: 0}
  end

  test "create a transaction" do
    assert Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z") == %Transaction{
             merchant: "Burger King",
             amount: 6,
             time: "2019-02-13T10:00:00.000Z"
           }
  end
end
