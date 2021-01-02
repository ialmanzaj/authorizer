defmodule TimeUtilsTest do
  use ExUnit.Case

  test "given date get the last two min ago" do
    assert TimeUtils.get_last_two_min_ago(~U[2019-02-13 10:01:00.000Z]) ==
             ~U[2019-02-13 09:59:00.000Z]
  end

  test "count transactions in a 2min inteval" do
    curr = Transaction.new("Burger King", 6, "2019-02-13T10:02:00.000Z")
    t1 = Transaction.new("Burger King", 6, "2019-02-13T10:00:01.000Z")
    t2 = Transaction.new("Burger King", 6, "2019-02-13T10:01:00.000Z")

    assert TimeUtils.count_transactions_last_two_min(curr, [t1, t2]) == 2
  end
end
