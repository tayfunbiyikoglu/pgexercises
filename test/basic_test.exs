defmodule BasicTest do
  use ExUnit.Case
  doctest Pgexercises
  alias Pgexercises.{Repo,Basic}
  alias Decimal, as: D

# Basic - Selectall
  test "Retrieve everything from a table" do
    facilities = Basic.all_facilities |> Repo.all
    assert Enum.count(facilities) == 9
  end

# Basic - Selectspecific
  test "Retrieve specific columns from a table" do
     facilities = Basic.get_name_and_membercost |> Repo.all
     assert Enum.count(facilities) == 9
     assert {_,_} = Enum.at(facilities, 0)
  end

# Basic - Where
  test "Control which rows are retrieved" do
    facilities = Basic.all_facilities_with_charge |> Repo.all
     assert Enum.count(facilities) == 5
     assert Enum.all?(facilities, fn facility -> facility.membercost > D.new(0) end) == true
  end

# Basic Where - 2
  test "Control which rows are retrieved - part 2" do
      facilities = Basic.basic_where_2 |> Repo.all
      assert Enum.count(facilities) == 2
    end

# Basic Where - 3
    test "Basic string searches" do
      facilities = Basic.basic_where_3 |> Repo.all
      assert Enum.count(facilities) == 3
      assert Enum.all?(facilities, fn facility -> String.match?(facility.name, ~r/Tennis/) end)
    end

# Basic Where - 4
    test "Matching against multiple possible values" do
      facilities = Basic.basic_where_4 |> Repo.all
      assert Enum.count(facilities) == 2
    end

# Basic Classify
    test "Classify results into buckets" do
      facilities = Basic.classify |> Repo.all
      assert Enum.count(facilities) == 9
    end

# Basic - Date
    test "Working with dates" do
      members = Basic.basic_date |> Repo.all
      assert Enum.count(members) == 10
    end

# Basic - Unique
    test "Removing duplicates, and ordering results" do
      members = Basic.basic_unique |> Repo.all
      assert Enum.count(members) == 10
      assert Enum.uniq(members) == members
    end

# Basic - Union
    test "Combining results from multiple queries" do
      {:ok, %{rows: result}} = Basic.basic_union
      assert Enum.count(result) == 34
    end

# Basic - Agg
    test "Simple aggregation" do
      [max_join_date] = Basic.basic_agg |> Repo.all
      assert max_join_date == {{2012, 09, 26}, {18, 08, 45}} |> Ecto.DateTime.from_erl
    end

# Basic - Agg 2
    test "More aggregation" do
      [{firstname, lastname, _joindate } ] = Basic.basic_agg_2 |> Repo.all
      assert firstname == "Darren"
      assert lastname == "Smith"
    end

end
