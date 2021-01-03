defmodule Authorizer do
  @moduledoc """
  Authorizer in charge of managing the state and coordinate actions
  """
  use GenServer
  alias Authorizer.{AccountValidator, TransactionValidator}

  # Client APIs
  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link(), do: GenServer.start_link(__MODULE__, 0)

  @spec get_current_account(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_current_account(account), do: GenServer.call(account, :account)

  @spec create_account(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def create_account(account, new_acount) do
    GenServer.call(account, {:create, new_acount})
  end

  @spec get_available_limit(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_available_limit(account), do: GenServer.call(account, :available_limit)

  def get_past_transactions(account), do: GenServer.call(account, :last_transactions)

  @spec is_card_active(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def is_card_active(account), do: GenServer.call(account, :card_active)

  def authorize_transaction(account, current_transaction),
    do: GenServer.call(account, {:authorize, current_transaction})

  # Server (callbacks)
  def start_app() do
    {:ok, pid} = start_link()
    pid
  end

  @impl true
  def init(_state) do
    {:ok, %{response: %Response{}, transactions: []}}
  end

  def handle_call(:account, _from, %{response: %Response{account: account}} = state),
    do: {:reply, account, state}

  def handle_call(:last_transactions, _from, %{transactions: transactions} = state),
    do: {:reply, transactions, state}

  @impl true
  def handle_call(
        :available_limit,
        _from,
        %{
          response: %Response{account: %Account{available_limit: available_limit}}
        } = state
      ),
      do: {:reply, available_limit, state}

  def handle_call(
        :card_active,
        _from,
        %{
          response: %Response{account: %Account{active_card: active_card}}
        } = state
      ),
      do: {:reply, active_card, state}

  def handle_call({:create, newAccount}, _from, %{response: %Response{account: account}} = state) do
    response = AccountValidator.validate_create_account(account)

    if response.valid? do
      {:reply, newAccount, %{state | response: %Response{account: newAccount}}}
    else
      {:reply, response, %{state | response: response}}
    end
  end

  def handle_call(
        {:authorize, current_transaction},
        _from,
        %{response: %Response{account: account}, transactions: transactions} = state
      ) do
    response =
      TransactionValidator.validate_transaction(account, current_transaction, transactions)

    if response.valid? do
      {:reply, response,
       %{state | response: response, transactions: [current_transaction | transactions]}}
    else
      {:reply, response, %{state | response: response}}
    end
  end
end
