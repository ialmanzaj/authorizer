defmodule Authorizer.AccountRulesTest do
  use ExUnit.Case
  alias Authorizer.{AccountRules}

  test "validate account already initialized" do
    account = %Account{active_card: true, available_limit: 100}

    assert AccountRules.validate_create_account(account) == %Response{
             data: account,
             valid?: false,
             violations: ["account-already-initialized"]
           }
  end

  test "validate account not initialized" do
    account = %Account{active_card: nil, available_limit: nil}

    assert AccountRules.validate_create_account(account) == %Response{
             data: account,
             valid?: true,
             violations: []
           }
  end
end
