defmodule Config.Validator do
  def validate(response, validator) do
    %{data: data, violations: violations} = response

    output =
      Enum.reduce([validator], response, fn validator, result ->
        case validator.(data) do
          :ok ->
            result

          {:invalid, reason} ->
            %{result | violations: [reason | violations], valid?: false}
        end
      end)

    output
  end
end
