defmodule Authorizer.CLI do
  def main(_args) do
    # Authorizer.Supervisor.start_link(name: Authorizer.Supervisor) |> IO.inspect()
    {:ok, account} = Authorizer.API.start_link([])
    ReaderStream.listen(account)
  end
end
