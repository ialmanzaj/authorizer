defmodule Account.Creation.Rules do
  @moduledoc false
  @doc """
  Rules for account creation validation
  """

  @spec validate_account_already_initialized(Account.t()) :: :ok | {:invalid, <<_::216>>}
  def validate_account_already_initialized(%Account{active_card: nil, available_limit: nil} = _) do
    :ok
  end

  def validate_account_already_initialized(%Account{active_card: _, available_limit: _} = _) do
    {:invalid, "account-already-initialized"}
  end

  def validate_card_not_active(%Account{} = account) do
    if account.active_card do
      :ok
    else
      {:invalid, "card-not-active"}
    end
  end

  def validate_account_not_initialized(%Account{active_card: nil, available_limit: nil} = _) do
    {:invalid, "account-not-initialized"}
  end

  def validate_account_not_initialized(%Account{active_card: _, available_limit: _} = _) do
    :ok
  end
end
