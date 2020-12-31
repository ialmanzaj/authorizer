defmodule Authorizer do
  @moduledoc """
  Authorizer in charge of managing the state and actions
  """
  use GenServer

  # Client APIs
  def start_link(), do: GenServer.start_link(__MODULE__, 0)

  def create_account(account, new_acount), do: GenServer.call(account, {:create, new_acount})

  def get_available_limit(account), do: GenServer.call(account, :available_limit)

  @spec is_card_active(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def is_card_active(account), do: GenServer.call(account, :card_active)

  @spec authorize_transaction(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def authorize_transaction(account, transaction),
    do: GenServer.call(account, {:authorize, transaction})

  def record_transaction(account, transaction),
    do: GenServer.call(account, {:record, transaction})

  # Server (callbacks)
  def start_app() do
    {:ok, pid} = start_link()
    pid
  end

  @impl true
  def init(_state) do
    {:ok, %Account{}}
  end

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

  def handle_call({:create, newAccount}, _from, _state), do: {:reply, :ok, newAccount}
end
