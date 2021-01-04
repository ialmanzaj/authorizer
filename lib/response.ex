defmodule Response do
  @derive {Poison.Encoder, except: [:valid?]}
  defstruct(account: %Account{}, violations: [], valid?: true)

  def new(account) do
    %Response{account: account, violations: [], valid?: true}
  end
end
