defmodule Response do
  defstruct(valid?: true, data: nil, violations: [])

  def new(data) do
    %Response{valid?: true, data: data, violations: []}
  end
end
