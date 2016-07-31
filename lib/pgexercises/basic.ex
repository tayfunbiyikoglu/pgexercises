defmodule Pgexercises.Basic do
  alias Pgexercises.{Facility,Member,Repo}
  import Ecto.Query, only: [from: 2]

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


  # Member Related Queries
    def all_members do
      Member
    end

  # How can you produce a list of members who joined after the start of September 2012?
  # Return the memid, surname, firstname, and joindate of the members in question.
    def basic_date do
      start_date = {{2012, 09, 01}, {0, 0, 0}} |> Ecto.DateTime.from_erl
      from m in all_members,
        where: m.joindate > ^start_date,
        select: {m.memid, m.surname, m.firstname, m.joindate}
    end

    # How can you produce an ordered list of the first 10 surnames in the members table?
    # The list must not contain duplicates.
    def basic_unique do
      from m in all_members,
      select: fragment("distinct surname"),
      limit: 10
    end

    # You, for some reason, want a combined list of all surnames and all facility names.
    # Yes, this is a contrived example :-). Produce that list!
    def basic_union do
      query = """
        select surname from cd.members
        union
        select name from cd.facilities
      """
      Ecto.Adapters.SQL.query(Repo,query, [])
    end

    # You'd like to get the signup date of your last member. How can you retrieve this information?
    def basic_agg do
      from m in all_members,
      select: max(m.joindate)
    end

    # You'd like to get the first and last name of the last member(s) who signed up - not just the date.
    #  How can you do that?
    def basic_agg_2 do
      from m in all_members,
      order_by: [desc: m.joindate],
      select: {m.firstname, m.surname, m.joindate},
      limit: 1
    end

end
