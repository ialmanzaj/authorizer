defmodule ReaderTest do
  use ExUnit.Case

  test "reading transaction from stdin" do
    assert ReaderStream.read() == %{
             "account" => %{"active-card" => true, "available-limit" => 100}
           }
  end

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
