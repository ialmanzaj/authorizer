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

  @tag :pending
  test "create an account and check limit", %{account: account} do
    new_account = %Account{active_card: true, available_limit: 100}
    Authorizer.create_account(account, new_account)
    assert Authorizer.get_available_limit(account) == 100
  end
end
