defmodule Pgexercises.Booking do
  use Ecto.Schema
  alias Pgexercises.{Repo,Member, Facility,Booking}
  import Ecto.Query, only: [from: 2]

  @primary_key {:bookid, :id, autogenerate: true}
  @schema_prefix "cd"

  schema "bookings" do
    belongs_to :facility, Facility, foreign_key: :facid, references: :facid
    belongs_to :member, Member, foreign_key: :memid, references: :memid
    field :starttime, Ecto.DateTime
    field :slot, :integer
  end

  def joins_simple_join do
    from b in Booking,
      join: m in assoc(b, :member),
      where: m.surname == "Farrell",
      where: m.firstname == "David",
      select: {b.starttime}
  end

  def joins_simple_join_2(start_date, end_date) do
    from b in Booking,
      join: f in assoc(b, :facility),
      where: fragment("starttime between ? and ?", type(^start_date, :datetime), type(^end_date, :datetime)),
      where: f.facid in [0,1],
      order_by: b.starttime,
      select: {b.starttime, f.name }
  end

  def three_join_base do
    from b in Booking,
    join: m in assoc(b, :member),
    join: f in assoc(b, :facility)
  end

  def three_join do
    from bmf in three_join_base,
    where: bmf.facid in [0,1],
    select: {
      fragment("firstname || ' ' || surname as member"),
      fragment("name as facility")
      },
    distinct: true
  end

  def three_join_2 do
    start_date = {{2012, 09, 14}, {0, 0, 0}} |> Ecto.DateTime.from_erl
    end_date = {{2012, 09, 15}, {0, 0, 0}} |> Ecto.DateTime.from_erl
    from bmf in three_join_base,
    select: {
      fragment("firstname || ' ' || surname as member"),
      fragment("name as facility"),
      fragment("""
                  case
		                when ? = 0 then slots*guestcost
		                else slots* membercost
                  end as cost
              """,bmf.memid)

      },
      where: bmf.starttime >= ^start_date,
      where: bmf.starttime < ^end_date,
      where: fragment("(? = 0 and slots*guestcost > 30) or (? != 0 and slots*membercost > 30)", bmf.memid,bmf.memid),
      order_by: fragment("cost desc")
  end
end
