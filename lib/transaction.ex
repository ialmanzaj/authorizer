defmodule Transaction do
  @moduledoc """
  """
  @doc """
  Transaction data structure
  """
  @enforce_keys [:merchant, :amount, :time]
  defstruct(merchant: "", amount: 0, time: nil)

  def new(merchant, amount, time) do
    %Transaction{merchant: merchant, amount: amount, time: parse_date(time)}
  end

  defp parse_date(datetime) do
    datetime
    |> NaiveDateTime.from_iso8601!()
    |> DateTime.from_naive!("Etc/UTC")
  end
end
