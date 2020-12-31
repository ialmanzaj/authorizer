defmodule Transaction.Auth.Rules do
  @moduledoc false
  @doc """
  Rules for transaction authorization validation
  """
  @spec validate_insufficient(Account.t(), Transaction.t()) :: :ok | {:invalid, <<_::144>>}
  def validate_insufficient(%Account{} = account, %Transaction{} = transaction) do
    if(account.available_limit > transaction.amount) do
      :ok
    else
      {:invalid, "insufficient-limit"}
    end
  end

  def validate_high_frequency_transactions(
        %Account{} = _,
        %Transaction{} = _,
        average_time_per_interval,
        count_transactions_per_interval
      ) do
    if count_transactions_per_interval >= 3 and average_time_per_interval <= 2 do
      {:invalid, "high-frequency-small-interval"}
    else
      :ok
    end
  end

  def validate_similar_transactions(
        %Account{} = _,
        %Transaction{} = transaction,
        %Transaction{} = last_transaction,
        time_last_transaction,
        current_time
      ) do
    time_interv = time_last_transaction - current_time

    if time_interv <= 2 and transaction.merchant == last_transaction.merchant and
         transaction.amount == last_transaction.amount do
      {:invalid, "doubled-transaction"}
    else
      :ok
    end
  end
end
