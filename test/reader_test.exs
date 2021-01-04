defmodule ReaderTest do
  use ExUnit.Case

  @tag :pending
  test "write output to user" do
    n1 = %Account{active_card: true, available_limit: 100}

    assert ReaderStream.parse_response_to_json(%Response{
             account: n1,
             valid?: true,
             violations: []
           }) == "{\"violations\":[],\"account\":{\"available_limit\":100,\"active_card\":true}}"
  end

  @tag :pending
  test "reading transaction from stdin" do
    assert ReaderStream.read() == %{
             "account" => %{"active-card" => true, "available-limit" => 100}
           }
  end

  @tag :pending
  test "reading account from stdin" do
    assert ReaderStream.read() == %{
             "transaction" => %{
               "amount" => 20,
               "merchant" => "Burger King",
               "time" => "2019-02-13T10:00:00.000Z"
             }
           }
  end
end
