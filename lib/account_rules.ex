defmodule Authorizer.AccountRules do
  @moduledoc false
  @doc """
  Rules for account creation validation
  """
  alias Config.Validator, as: Validator

  def validate_create_account(account) do
    response = Response.new(account)

    response
    |> IO.inspect()
    |> validate_account_already_initialized()
  end

  @spec validate_account_already_initialized(any) :: none
  defp validate_account_already_initialized(%Response{} = response) do
    Validator.validate(response, fn account ->
      account |> IO.inspect()
    end)
  end

  defp check_is_already_initialized(%Account{active_card: nil, available_limit: nil}) do
    :ok
  end

  defp check_is_already_initialized(%Account{active_card: _, available_limit: _}) do
    {:invalid, "account-already-initialized"}
  end
end
