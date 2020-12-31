defmodule Account.Validator do
  @type reason :: String.t()
  @type result :: %{account: Enum.t(), violations: [reason()]}
  alias Account.Creation.Rules, as: CreationRules

  def validate_account_creation(account_state, account_data) do
    result = %{
      account: account_state,
      violations: []
    }

    result
    |> CreationRules.validate_account_already_initialized()
  end

  def validate_transactions(account_state, transactions, curr_transaction) do
    result = %{
      account: account_state,
      violations: []
    }

    result
  end

  defp required() do
    fn
      nil -> {:invalid, "is required"}
      _other -> :ok
    end
  end

  def validation(initial_result, validators) do
    value = get_in(initial_result, [:account])

    Enum.reduce(validators, initial_result, fn validator, result ->
      case validator.(value) do
        :ok ->
          result

        {:invalid, reason} ->
          update_in(result, [:violations], fn
            nil -> [reason]
            other_reasons -> [reason | other_reasons]
          end)
      end
    end)
  end
end
