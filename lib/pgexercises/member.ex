defmodule Pgexercises.Member do
  use Ecto.Schema
  alias Pgexercises.{Repo,Member,Booking}
  import Ecto.Query, only: [from: 2]

  @primary_key {:memid, :id, autogenerate: true}
  @schema_prefix "cd"

  schema "members" do
    field :surname, :string
    field :firstname, :string
    field :address, :string
    field :zipcode, :integer
    field :telephone, :string
    belongs_to :recommender, Member, foreign_key: :recommendedby, references: :memid
    has_many :recommendations, Member, foreign_key: :memid
    field :joindate, Ecto.DateTime
    has_many :bookings, Booking, foreign_key: :memid
  end

  def all_members do
    Member
  end

  def basic_date do
    start_date = {{2012, 09, 01}, {0, 0, 0}} |> Ecto.DateTime.from_erl
    from m in all_members,
      where: m.joindate > ^start_date,
      select: {m.memid, m.surname, m.firstname, m.joindate}
  end

  def basic_unique do
    from m in all_members,
    select: fragment("distinct surname"),
    limit: 10
  end

  def basic_union do
    query = """
      select surname from cd.members
      union
      select name from cd.facilities
    """
    Ecto.Adapters.SQL.query(Repo,query, [])
  end

  def basic_agg do
    from m in all_members,
    select: max(m.joindate)
  end

  def basic_agg_2 do
    from m in all_members,
    order_by: [desc: m.joindate],
    select: {m.firstname, m.surname, m.joindate},
    limit: 1
  end

  def self_join do
    from m in all_members,
      join: rec in assoc(m, :recommender),
      order_by: [rec.surname, rec.firstname],
      select: {rec.firstname,rec.surname},
      distinct: true
  end

  def self_join_2 do
    from m in all_members,
      left_join: rec in assoc(m, :recommender),
      order_by: [m.surname, m.firstname],
      select: { m.firstname,m.surname, rec.firstname,rec.surname}
  end


end
