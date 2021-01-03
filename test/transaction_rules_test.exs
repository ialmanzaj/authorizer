defmodule Authorizer.TransactionValidatorTest do
  use ExUnit.Case
  alias Authorizer.{TransactionValidator}

  @tag :pending
  test "validate two similar transactions in a 2min inteval" do
    account = %Account{active_card: true, available_limit: 100}
    t1 = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")
    t2 = Transaction.new("Burger King", 6, "2019-02-13T10:01:00.000Z")

    assert TransactionValidator.validate_similar_transactions(
             %Response{
               account: account,
               violations: [],
               valid?: true
             },
             t1,
             t2
           ) == %Response{
             account: %Account{active_card: true, available_limit: 100},
             violations: ["doubled-transaction"],
             valid?: false
           }
  end

  test "validate a transaction when account dont have available limit " do
    account = %Account{active_card: true, available_limit: 0}
    curr = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionValidator.validate_transaction(account, curr, []) == %Response{
             account: account,
             violations: ["insufficient-limit"],
             valid?: false
           }
  end

  test "validate a transaction when account is not initialized" do
    account = %Account{active_card: nil, available_limit: nil}
    t = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionValidator.validate_transaction(account, t, []) == %Response{
             account: account,
             violations: ["card-not-active", "account-not-initialized"],
             valid?: false
           }
  end
end
