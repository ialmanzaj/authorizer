defmodule ReaderStream do
  @moduledoc """
  Api to read input from stdin as streaming using proceses.
  """
  alias Authorizer.{Parser}

  def str() do
    StringIO.open("foo", [capture_prompt: true], fn pid ->
      input = IO.gets(pid, ">")
      IO.write(pid, "The input was #{input}")
      StringIO.contents(pid)
    end)
  end

  def read() do
    input_decoded =
      IO.read(:stdio, :line)
      |> String.trim()
      |> Poison.decode()

    case input_decoded do
      {:ok, obj} ->
        obj

      _ ->
        {:error, "Error decoding "}
    end
  end
end

ReaderStream.str()
