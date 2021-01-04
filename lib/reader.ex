defmodule ReaderStream do
  @moduledoc """
  Api to read input from stdin as streaming using proceses.
  """
  require Logger

  def parse_response_to_json(%Response{} = response) do
    {_, json} =
      response
      |> Poison.encode()

    json
  end

  def write_output(response) do
    parse_response_to_json(response)
    |> IO.write()
  end

  @spec read_input :: false | nil | true | binary | [any] | number | map
  def read_input() do
    input_decoded =
      IO.read(:stdio, :line)
      |> Poison.decode()

    case input_decoded do
      {:ok, obj} ->
        obj

      _ ->
        {:error, "Error decoding "}
    end
  end
end
