class StatsController < ApplicationController
  def stats
    result = google_api_client.execute(:api_method => google_calendar.events.list,
                                :parameters => {'calendarId' => 'primary'},
                                :authorization => user_credentials)
    items = result.data.items
    items = items.select { |i| i.kind == "calendar#event" }

    # nextPageToken
    current_user.update_calendar items

    @events         = Event.sum(:duration, group: "DATE(start_time)")
    @events_weekday = Event.sum(:duration, group: "strftime('%w', start_time)")
  end
end
