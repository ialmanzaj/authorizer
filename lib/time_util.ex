defmodule TimeUtils do
  def get_last_two_min_ago(time) do
    DateTime.add(time, -120, :second)
  end

  def get_time_difference_in_minute(t1, t2) do
    Time.diff(t1, t2)
    |> abs()
    |> div(60)
  end

  @spec are_in_two_min_interval?(
          %{calendar: atom, hour: any, microsecond: {any, any}, minute: any, second: any},
          %{calendar: atom, hour: any, microsecond: {any, any}, minute: any, second: any}
        ) :: boolean
  def are_in_two_min_interval?(t1, t2) do
    get_time_difference_in_minute(t1, t2) <= 2
  end

  @spec count_transactions_last_two_min(any, any) :: non_neg_integer
  def count_transactions_last_two_min(_, transactions) when length(transactions) < 2, do: 0

  def count_transactions_last_two_min(%Transaction{time: curr_time}, past_transactions) do
    past_transactions
    |> Enum.map(fn t ->
      t.time <= curr_time and t.time >= TimeUtils.get_last_two_min_ago(curr_time)
    end)
    |> Enum.filter(fn t -> t == true end)
    |> Enum.count()
  end

  def count_transactions_last_two_min(_, []), do: 0
end
