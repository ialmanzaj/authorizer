defmodule AuthorizerTest do
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

  test "check initial account", %{account: account} do
    assert Authorizer.get_current_account(account) == %Account{
             active_card: nil,
             available_limit: nil
           }
  end

  # @tag :pending
  test "create an account and check limit", %{account: account} do
    assert Authorizer.get_current_account(account) == %Account{
             active_card: nil,
             available_limit: nil
           }

    n1 = %Account{active_card: true, available_limit: 100}

    assert Authorizer.create_account(account, n1) == n1

    n2 = %Account{active_card: true, available_limit: 300}

    assert Authorizer.create_account(account, n2) == %Response{
             account: n1,
             violations: ["account-already-initialized"],
             valid?: false
           }
  end

  test "authorizing a transaction with account inicialized and card desactive", %{
    account: account
  } do
    empty_account = %Account{
      active_card: nil,
      available_limit: nil
    }

    n1 = %Account{active_card: true, available_limit: 100}

    assert Authorizer.create_account(account, n1) == n1

    t1 = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert Authorizer.authorize_transaction(account, t1) == %Response{
             account: n1,
             valid?: true,
             violations: []
           }

    t2 = Transaction.new("Burger King", 6, "2019-02-13T10:01:00.000Z")
  end

  test "validate two similar transactions in a 2min inteval", %{
    account: account
  } do
    n1 = %Account{active_card: true, available_limit: 100}
    assert Authorizer.create_account(account, n1) == n1

    t1 = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")
    t2 = Transaction.new("Burger King", 6, "2019-02-13T10:01:00.000Z")

    assert Authorizer.authorize_transaction(account, t1) == %Response{
             account: n1,
             valid?: true,
             violations: []
           }

    assert Authorizer.get_past_transactions(account) == [t1]

    assert Authorizer.authorize_transaction(account, t2) == %Response{
             account: n1,
             violations: ["doubled-transaction"],
             valid?: false
           }
  end
end
