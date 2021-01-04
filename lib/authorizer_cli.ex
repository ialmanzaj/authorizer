defmodule Authorizer.CLI do
  alias Authorizer.{Parser}

  def main(_args) do
    # Authorizer.Supervisor.start_link(name: Authorizer.Supervisor) |> IO.inspect()
    {:ok, account} = Authorizer.API.start_link([])
    listen(account)
  end

  @spec listen(atom | pid | {atom, any} | {:via, atom, any}) :: no_return
  def listen(account) do
    case ReaderStream.read() do
      {:ok, decoded_input} ->
        account
        |> Authorizer.API.execute(decoded_input)
        |> Parser.encode_response()
        |> add_next_line()
        |> IO.write()

      {:error, msg} ->
        IO.write(:stdio, msg)
    end

    listen(account)
  end

  defp add_next_line(word) do
    word <> "\n"
  end
end
