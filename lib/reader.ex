defmodule ReaderStream do
  @moduledoc """
  Api to read input from stdin as streaming using proceses.
  """
  require Logger
  alias Authorizer.{Parser}

  def listen(account) do
    case read() do
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

  defp read() do
    input =
      IO.gets("Authorizer app: --->\n")
      |> Poison.decode()

    case input do
      {:ok, input} ->
        {:ok, Parser.parse(input)}

      {:error, _, _} ->
        {:error, "Error decoding\n"}
    end
  end
end
