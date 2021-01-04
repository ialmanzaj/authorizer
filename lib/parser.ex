defmodule Authorizer.Parser do
  @spec parse(map) :: any
  def parse(%{"account" => %{"active-card" => active, "available-limit" => limit}}) do
    %Account{active_card: active, available_limit: limit}
  end

  def parse(%{"transaction" => %{"merchant" => merchant, "amount" => amount, "time" => time}}) do
    %Transaction{merchant: merchant, amount: amount, time: time}
  end

  def encode_response(%Response{} = response) do
    {_, json} =
      response
      |> Poison.encode()

    json
  end
end
