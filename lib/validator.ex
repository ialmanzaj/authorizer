defmodule Authorizer.Validator do
  @spec validate(Response.t(), (any -> any)) :: Response.t()
  def validate(%Response{account: account, violations: violations} = response, validator) do
    case validator.(account) do
      :ok ->
        response

      {:invalid, reason} ->
        %{response | violations: [reason | violations], valid?: false}
    end
  end
end
