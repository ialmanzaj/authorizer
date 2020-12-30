defmodule Account do
  defstruct [:active_card, :available_limit]

  def new() do
    %Account{}
  end

  def decrement(account, amount) do
    %Account{account | available_limit: account.available_limit - amount}
  end
end

defmodule Transaction do
  defstruct [:merchant, :amount, :time]
end

defmodule Api do
  @moduledoc """
  Documentation for `Api`.
  """

  @doc """

  """

  def read_data(%{"account" => %{"active-card" => active, "available-limit" => limit}}) do
    # def read_data() do
    # input |> IO.inspect(label: "yess! ")
    IO.puts("read_data-account")
  end

  def read_data(%{
        "transaction" => %{"merchant" => merchant, "amount" => amount, "time" => time}
      }) do
    merchant |> IO.inspect(label: "yess! ")
    amount |> IO.inspect(label: "yess! ")
    time |> IO.inspect(label: "yess! ")
  end

  def get_input() do
    {_, json} =
      IO.read(:stdio, :line)
      |> String.trim()
      |> Poison.decode()

    read_data(json)
    get_input()
  end
end

Api.get_input()
