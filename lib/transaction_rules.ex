defmodule Authorizer.TransactionValidator do
  @moduledoc false
  @doc """
  Rules for transaction authorization validation
  """
  alias Authorizer.Validator, as: Validator

  def validate_transaction(
        %Account{} = account,
        %Transaction{} = current_transaction,
        past_transactions
      ) do
    response = Response.new(account)

    response
    |> validate_account_not_initialized()
    |> validate_card_not_active()
    |> validate_insufficient_limit(current_transaction)
    |> validate_high_frequency_transactions(current_transaction, past_transactions)
    |> validate_similar_transactions(current_transaction, List.last(past_transactions))
  end

  defp validate_account_not_initialized(%Response{} = response) do
    Validator.validate(response, fn account ->
      check_is_not_initialized(account)
    end)
  end

  defp check_is_not_initialized(%Account{active_card: nil, available_limit: nil}) do
    {:invalid, "account-not-initialized"}
  end

  defp check_is_not_initialized(%Account{active_card: _, available_limit: _}) do
    :ok
  end

  defp validate_card_not_active(%Response{} = response) do
    Validator.validate(response, fn account ->
      if account.active_card do
        :ok
      else
        {:invalid, "card-not-active"}
      end
    end)
  end

  defp validate_insufficient_limit(
         %Response{} = response,
         %Transaction{} = transaction
       ) do
    Validator.validate(response, fn account ->
      if(account.available_limit > transaction.amount) do
        :ok
      else
        {:invalid, "insufficient-limit"}
      end
    end)
  end

  defp validate_high_frequency_transactions(%Response{} = response, %Transaction{}, []) do
    Validator.validate(response, fn _ ->
      :ok
    end)
  end

  defp validate_high_frequency_transactions(
         %Response{} = response,
         %Transaction{} = curr_transaction,
         transactions
       ) do
    Validator.validate(response, fn _ ->
      count = TimeUtils.count_transactions_last_two_min(curr_transaction, transactions)

      if count >= 3 do
        {:invalid, "high-frequency-small-interval"}
      else
        :ok
      end
    end)
  end

  defp validate_similar_transactions(
         %Response{} = response,
         %Transaction{merchant: merchant, amount: amount, time: time},
         %Transaction{merchant: last_merchant, amount: last_amount, time: last_time}
       ) do
    Validator.validate(response, fn _ ->
      if merchant == last_merchant and amount == last_amount and
           TimeUtils.are_in_two_min_interval?(time, last_time) do
        {:invalid, "doubled-transaction"}
      else
        :ok
      end
    end)
  end

  defp validate_similar_transactions(%Response{} = response, %Transaction{}, nil) do
    Validator.validate(response, fn _ ->
      :ok
    end)
  end
end
