defmodule Authorizer do
  @moduledoc """
  Authorizer in charge of managing the state and coordinate actions
  """
  use GenServer
  alias Authorizer.{AccountRules, TransactionRules}

  # Client APIs
  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link(), do: GenServer.start_link(__MODULE__, 0)

  def get_current_account(account), do: GenServer.call(account, :account)

  def create_account(account, new_acount) do
    GenServer.call(account, {:create, new_acount})
  end

  @spec get_available_limit(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_available_limit(account), do: GenServer.call(account, :available_limit)

  @spec is_card_active(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def is_card_active(account), do: GenServer.call(account, :card_active)

  @spec authorize_transaction(Account.t(), Transaction.t(), [any]) :: nil
  def authorize_transaction(
        account,
        %Transaction{} = current_transaction,
        past_transactions
      ) do
    response =
      TransactionRules.validate_transaction(account, current_transaction, past_transactions)

    if response.valid do
      GenServer.call(account, {:authorize, current_transaction})
    else
      # send an output to the stdin with the response
      # GenServer.call(account, {:create, new_acount})
    end
  end

  # Server (callbacks)
  def start_app() do
    {:ok, pid} = start_link()
    pid
  end

  @impl true
  def init(_state) do
    {:ok, %Account{}}
  end

  def handle_call(:account, _from, state), do: {:reply, state, state}

  @impl true
  def handle_call(
        :available_limit,
        _from,
        %{active_card: _, available_limit: available_limit} = state
      ),
      do: {:reply, available_limit, state}

  def handle_call(
        :card_active,
        _from,
        %{active_card: card_active, available_limit: _} = state
      ),
      do: {:reply, card_active, state}

  def handle_call({:create, newAccount}, _from, state) do
    # response = AccountRules.validate_create_account(state)
    IO.inspect(state)
    # if response.valid do
    {:reply, :ok, newAccount}
    # end
  end
end
