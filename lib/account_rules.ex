defmodule AccountRules do
  @moduledoc false
  @doc """
  Rules for account creation validation
  """
  alias Config.Validator, as: Validator

  def validate_create_account(account) do
    response = Response.new(account)

    response
    |> validate_account_already_initialized()
  end

  @spec validate_account_already_initialized(any) :: none
  def validate_account_already_initialized(%Response{} = response) do
    Validator.validate_change(response, fn account ->
      is_already_initialized(account)
    end)
  end

  defp is_already_initialized(%Account{active_card: nil, available_limit: nil}) do
    :ok
  end

  defp is_already_initialized(%Account{active_card: _, available_limit: _}) do
    {:invalid, "account-already-initialized"}
  end
end
