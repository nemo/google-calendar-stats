class StatsController < ApplicationController
  def stats
    # nextPageToken
    current_user.update_calendar!

    @events            = Event.sum('duration', group: "DATE(start_time)", order: "DATE(start_time) asc")
    @events_weekday    = Event.sum('duration', group: "EXTRACT(DOW FROM start_time)", order: "EXTRACT(DOW FROM start_time) asc")
    @events_dayofmonth = Event.sum('duration', group: "EXTRACT(DAY FROM start_time)", order: "EXTRACT(DAY FROM start_time) asc")
  end
end
