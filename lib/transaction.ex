defmodule Transaction do
  @moduledoc """
  """
  @doc """
  Transaction data structure
  """
  @enforce_keys [:merchant, :amount, :time]
  defstruct(merchant: "", amount: 0, time: "")

  def new(merchant, amount, time) do
    %Transaction{merchant: merchant, amount: amount, time: time}
  end
end
