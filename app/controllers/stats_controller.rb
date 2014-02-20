class StatsController < ApplicationController
  def update_stats
    current_user.update_calendar!

    redirect_to stats_path, notice: 'Updated your Google Calendar Events'
  end

  def stats
    redirect_to update_stats_path unless current_user.events.count > 0

    @events            = current_user.events.sum('duration', group: "DATE(start_time)", order: "DATE(start_time) asc")
    @events_weekday    = current_user.events.sum('duration', group: "EXTRACT(DOW FROM start_time)", order: "EXTRACT(DOW FROM start_time) asc")
    @events_dayofmonth = current_user.events.sum('duration', group: "EXTRACT(DAY FROM start_time)", order: "EXTRACT(DAY FROM start_time) asc")
  end
end
