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
    n2 = %Account{active_card: true, available_limit: 300}
    assert Authorizer.create_account(account, n1) == n1
    assert Authorizer.get_available_limit(account) == 100

    assert Authorizer.create_account(account, n2) == %Response{
             account: %Account{active_card: true, available_limit: 100},
             violations: ["account-already-initialized"],
             valid?: false
           }

    assert Authorizer.get_current_account(account) == n1
  end
end
