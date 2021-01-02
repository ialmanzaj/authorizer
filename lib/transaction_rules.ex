defmodule TransactionRules do
  @moduledoc false
  @doc """
  Rules for transaction authorization validation
  """
  alias Config.Validator, as: Validator

  def validate_transaction(
        %Account{} = account,
        %Transaction{} = current_transaction,
        last_three_transactions
      ) do
    response = Response.new(account)

    response
    |> validate_account_not_initialized()
    |> validate_card_not_active()
    |> validate_insufficient_limit(current_transaction)
    # |> validate_high_frequency_transactions(current_transaction, last_transactions)
    |> validate_similar_transactions(current_transaction, List.last(last_three_transactions))
  end

  defp validate_account_not_initialized(%Response{} = response) do
    Validator.validate(response, fn account ->
      is_not_initialized(account)
    end)
  end

  defp is_not_initialized(%Account{active_card: nil, available_limit: nil}) do
    {:invalid, "account-not-initialized"}
  end

  defp is_not_initialized(%Account{active_card: _, available_limit: _}) do
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

  def count_transactions_last_two_min(transactions) when length(transactions) < 3, do: 0

  @spec count_transactions_last_two_min(nonempty_maybe_improper_list) :: any
  def count_transactions_last_two_min([head | tail] = transactions) do
    # how
    # start_time - end_time  ->  2 minute interval: current_time - last_2_minutes
    # find transaction in the last 2 minutes
    transactions
    |> Enum.chunk_every(2)
  end

  def count_transactions_last_two_min([]), do: 0

  defp compare([head | tail]) do
    tail
  end

  defp get_diff_from_dates(t1, t2) do
    div(Time.diff(t1, t2), 60)
  end

  defp are_in_two_min_interval?(t1, t2) do
    get_diff_from_dates(t1, t2) <= 2
  end

  defp validate_high_frequency_transactions(%Response{} = response, transactions) do
    Validator.validate(response, fn _ ->
      count = count_transactions_last_two_min(transactions)

      if count >= 3 do
        {:invalid, "high-frequency-small-interval"}
      else
        :ok
      end
    end)
  end

  # defp last_transaction(transactions) do
  #
  # end

  defp validate_similar_transactions(
         %Response{} = response,
         %Transaction{merchant: merchant, amount: amount, time: time},
         %Transaction{merchant: last_merchant, amount: last_amount, time: last_time}
       ) do
    Validator.validate(response, fn _ ->
      if merchant == last_merchant and amount == last_amount and
           are_in_two_min_interval?(time, last_time) do
        {:invalid, "doubled-transaction"}
      else
        :ok
      end
    end)
  end
end
