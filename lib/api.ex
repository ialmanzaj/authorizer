defmodule Api do
  @moduledoc """
  """
  @doc """
  """

  @spec read_data(map) :: any
  def read_data(%{"account" => %{"active-card" => _, "available-limit" => _}} = account) do
    struct(account, Account)
    |> IO.inspect(label: "reading account")
  end

  def read_data(
        %{
          "transaction" => %{"merchant" => _, "amount" => _, "time" => _}
        } = transaction
      ) do
    struct(transaction, Transaction)
    |> IO.inspect(label: "reading transaction")
  end

  @spec get_input :: no_return
  def get_input() do
    {_, json} =
      IO.read(:stdio, :line)
      |> String.trim()
      |> Poison.decode()

    read_data(json)
    get_input()
  end
end
