defmodule TransactionTest do
  use ExUnit.Case

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
end
