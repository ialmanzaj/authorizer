defmodule Authorizer.TransactionRulesTest do
  use ExUnit.Case
  alias Authorizer.{TransactionRules}

  test "validate a transaction when account dont have available limit " do
    account = %Account{active_card: true, available_limit: 0}
    curr = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionRules.validate_transaction(account, curr, []) == %Response{
             data: account,
             valid?: false,
             violations: ["insufficient-limit"]
           }
  end

  test "validate a transaction when account is not initialized" do
    account = %Account{active_card: nil, available_limit: nil}
    t = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")

    assert TransactionRules.validate_transaction(account, t, []) == %Response{
             data: account,
             valid?: false,
             violations: ["card-not-active", "account-not-initialized"]
           }
  end

  test "validate two similar transactions in a 2min inteval" do
    account = %Account{active_card: true, available_limit: 100}
    t1 = Transaction.new("Burger King", 6, "2019-02-13T10:00:00.000Z")
    t2 = Transaction.new("Burger King", 6, "2019-02-13T10:01:00.000Z")

    assert TransactionRules.validate_similar_transactions(
             %Response{
               data: account,
               valid?: true,
               violations: []
             },
             t1,
             t2
           ) == %Response{
             data: %Account{active_card: true, available_limit: 100},
             valid?: false,
             violations: ["doubled-transaction"]
           }
  end
end
