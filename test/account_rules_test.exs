defmodule Authorizer.AccountValidatorTest do
  use ExUnit.Case
  alias Authorizer.{AccountValidator}

  test "validate account already initialized" do
    account = %Account{active_card: true, available_limit: 100}

    assert AccountValidator.validate_create_account(account) == %Response{
             account: account,
             violations: ["account-already-initialized"],
             valid?: false
           }
  end

  test "validate account not initialized" do
    account = %Account{active_card: nil, available_limit: nil}

    assert AccountValidator.validate_create_account(account) == %Response{
             account: account,
             violations: [],
             valid?: true
           }
  end
end
