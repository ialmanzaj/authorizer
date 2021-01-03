defmodule Response do
  defstruct(account: %Account{}, violations: [], valid?: true)

  def new(account) do
    %Response{account: account, violations: [], valid?: true}
  end
end
