defmodule Pgexercises.Facility do
  use Ecto.Schema
  alias Pgexercises.{Repo,Facility}
  import Ecto.Query, only: [from: 2]

  @primary_key {:facid, :id, autogenerate: true}
  @schema_prefix "cd"

  schema "facilities" do
    field :name, :string
    field :membercost, :integer
    field :guestcost, :integer
    field :initialoutlay, :integer
    field :monthlymaintenance, :integer
    has_many :bookings, Booking, foreign_key: :memid
  end

  # How can you retrieve all the information from the cd.facilities table?
  def all_facilities do
    Facility
  end

  # You want to print out a list of all of the facilities and their cost to members.
  # How would you retrieve a list of only facility names and costs?
  def get_name_and_membercost do
    from f in all_facilities, select: {f.name, f.membercost}
  end

  # How can you produce a list of facilities that charge a fee to members?
  def all_facilities_with_charge do
    from f in all_facilities, where: f.membercost > 0
  end

  # How can you produce a list of facilities that charge a fee to members,
  # and that fee is less than 1/50th of the monthly maintenance cost?
  # Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
  def basic_where_2 do
    from f in all_facilities_with_charge,
      where: fragment("membercost < monthlymaintenance/50"),
      select: {f.facid, f.name, f.membercost,f.monthlymaintenance}
  end

  # How can you produce a list of all facilities with the word 'Tennis' in their name?
  def basic_where_3 do
    from f in all_facilities, where: like(f.name, "%Tennis%")
  end

  # How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
  def basic_where_4 do
    from f in all_facilities, where: f.facid in [1,5]
  end

  # How can you produce a list of facilities, with each labelled as 'cheap' or 'expensive'
  # depending on if their monthly maintenance cost is more than $100?
  # Return the name and monthly maintenance of the facilities in question.
  def classify do
    from f in all_facilities, select: fragment("name, case when monthlymaintenance > 100 then 'expensive' else 'cheap' end")
  end

  def basic_date do

  end

end
