defmodule Authorizer.AccountValidator do
  @moduledoc false
  @doc """
  Rules for account creation validation
  """
  alias Authorizer.Validator, as: Validator

  def validate_create_account(account) do
    response = Response.new(account)

    response
    |> validate_account_already_initialized()
  end

  defp validate_account_already_initialized(response) do
    Validator.validate(response, fn account ->
      check_is_already_initialized(account)
    end)
  end

  defp check_is_already_initialized(%Account{active_card: nil, available_limit: nil}) do
    :ok
  end

  defp check_is_already_initialized(%Account{active_card: _, available_limit: _}) do
    {:invalid, "account-already-initialized"}
  end
end
