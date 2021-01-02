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

  @tag :pending
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

  @tag :pending
  test "decrement an account" do
    account = Account.new(true, 50)
    assert Account.decrement(account, 50) == %Account{active_card: true, available_limit: 0}
  end

  test "create a transaction" do
    assert Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z") == %Transaction{
             merchant: "Burger King",
             amount: 6,
             time: ~U[2019-02-13 10:00:00.000Z]
           }
  end

  test "parsing date in a transaction" do
    assert Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z") == %Transaction{
             merchant: "Burger King",
             amount: 6,
             time: ~U[2019-02-13 10:00:00.000Z]
           }
  end

  @tag :pending
  test "checking account is initialized" do
    account = %Account{active_card: true, available_limit: 100}

    assert AccountRules.validate_account_already_initialized(account) ==
             {:invalid, "account-already-initialized"}
  end

  @tag :pending
  test "checking account is not initialized" do
    account = %Account{active_card: nil, available_limit: nil}
    assert AccountRules.validate_account_already_initialized(account) == :ok
  end

  test "check account is not initialized" do
    account = %Account{active_card: nil, available_limit: nil}

    assert AccountRules.validate_create_account(account) == %Response{
             data: account,
             valid?: true,
             violations: []
           }
  end

  test "validate if account already initialized" do
    account = %Account{active_card: true, available_limit: 100}

    assert AccountRules.validate_create_account(account) == %Response{
             data: account,
             valid?: false,
             violations: ["account-already-initialized"]
           }
  end

  test "validate a transaction when is not initialized" do
    account = %Account{active_card: nil, available_limit: nil}
    t = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionRules.validate_transaction(account, t, []) == %Response{
             data: account,
             valid?: false,
             violations: ["card-not-active", "account-not-initialized"]
           }
  end

  test "validate a transaction when is run out of available limit " do
    account = %Account{active_card: true, available_limit: 0}
    t = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionRules.validate_transaction(account, t, []) == %Response{
             data: account,
             valid?: false,
             violations: ["insufficient-limit"]
           }
  end

  test "time diference" do
    dif = Time.diff(~U[2019-02-13 10:01:00.000Z], ~U[2019-02-13 10:00:00.000Z])
    assert dif == 60
  end

  test "time of transactions" do
    t = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")
    assert TransactionRules.count_transactions_last_two_min([t, t, t]) == nil
  end
end
