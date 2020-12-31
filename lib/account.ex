defmodule Account do
  @moduledoc """
  """
  @doc """
  Account data structure
  """
  defstruct(active_card: nil, available_limit: nil)

  def new() do
    %Account{}
  end

  def new(active_card, available_limit) do
    %Account{active_card: active_card, available_limit: available_limit}
  end

  def decrement(account, amount) do
    %Account{account | available_limit: account.available_limit - amount}
  end
end
