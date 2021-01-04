defmodule ReaderStream do
  @moduledoc """
  Api to read input from stdin as streaming using proceses.
  """
  require Logger
  alias Authorizer.{Parser}

  def read() do
    input =
      IO.read(:stdio, :line)
      |> Poison.decode()

    case input do
      {:ok, input} ->
        {:ok, Parser.parse(input)}

      {:error, _, _} ->
        {:error, "Error decoding\n"}
    end
  end
end
