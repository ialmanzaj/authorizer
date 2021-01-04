defmodule Authorizer.CLI do
  def main(_args) do
    Authorizer.Supervisor.start_link(name: Authorizer.Supervisor)
  end
end
