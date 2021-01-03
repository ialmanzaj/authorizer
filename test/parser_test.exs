defmodule ParserTest do
  use ExUnit.Case
  alias Authorizer.{Parser}

  test "parsing a account json" do
    obj = %{"account" => %{"active-card" => true, "available-limit" => 100}}
    assert Parser.parse(obj) == %Account{active_card: true, available_limit: 100}
  end

  test "parsing a transaction json" do
    obj = %{
      "transaction" => %{
        "amount" => 20,
        "merchant" => "Burger King",
        "time" => "2019-02-13T10:00:00.000Z"
      }
    }

    assert Parser.parse(obj) == %Transaction{
             amount: 20,
             merchant: "Burger King",
             time: "2019-02-13T10:00:00.000Z"
           }
  end
end
