defmodule ApiTest do
  use ExUnit.Case

  setup do
    account = Authorizer.start_app()
    {:ok, account: account}
  end

  test "initial account is nil", %{account: account} do
    assert Authorizer.get_available_limit(account) == nil
  end

  test "initial card is not active", %{account: account} do
    assert Authorizer.is_card_active(account) == nil
  end

  test "create an account and check limit", %{account: account} do
    assert Authorizer.get_available_limit(account) == nil
    Authorizer.create_account(account, %Account{active_card: true, available_limit: 100})
    assert Authorizer.get_available_limit(account) == 100
  end

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
