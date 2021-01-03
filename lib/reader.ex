defmodule Reader do
  @moduledoc """
  Api to read input from stdin as streaming using proceses.
  """

  @spec parse(map) :: any
  def parse(%{"account" => %{"active-card" => active, "available-limit" => limit}} = account) do
    account
    |> IO.inspect(label: "account: ->")
  end

  def parse(%{"transaction" => %Transaction{}} = transaction) do
    transaction
    |> IO.inspect(label: "transaction: ->")
  end

  def read() do
    {_, json} =
      IO.read(:stdio, :line)
      |> Poison.decode()

    parse(json)
    read()
  end
end
