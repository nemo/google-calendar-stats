class User < ActiveRecord::Base
  def google_authorization
    cached_credentials = self.attributes
    authorization = Signet::OAuth2::Client.new(cached_credentials)
    authorization.issued_at = Time.at(cached_credentials['issued_at'])
    if authorization.expired?
      authorization.fetch_access_token!
      self.update_credentials(authorization)
    end
    authorization
  end

  def update_credentials(authorization=nil)

    unless authorization.refresh_token.nil?
      hash = {}
      %w'access_token
       authorization_uri
       client_id
       client_secret
       expires_in
       refresh_token
       token_credential_uri'.each do |var|
        hash[var] = authorization.instance_variable_get("@#{var}").to_s
      end
      hash['issued_at'] = authorization.issued_at.to_i

      self.update_attributes! hash
    end
  end


  def update_calendar!
    page_token = nil
    result = google_api_client.execute(:api_method => google_calendar.events.list,
                                :parameters => {'calendarId' => 'primary'},
                                :authorization => google_authorization)

    while true
      events = result.data.items
      events = events.select { |i| i.kind == "calendar#event" }

      self.update_events events

      if !(page_token = result.data.next_page_token)
        break
      end
      result = google_api_client.execute(:api_method => google_calendar.events.list,
                                :parameters => {'calendarId' => 'primary',
                                                'pageToken' => page_token},
                                :authorization => google_authorization)
    end

  end

  def update_events(events=[])
    events.each do |data|
      event = Event.where(event_id: data["id"]).first || Event.new

      next unless (data["end"] and data["start"]["dateTime"])

      start_time = data["start"]["dateTime"].to_datetime
      end_time   = data["end"]["dateTime"].to_datetime

      # skip if even is in the future
      next if start_time > DateTime.now

      event.update_attributes!({ 
        start_time:   start_time,
        end_time:     end_time,
        html_link:    data["htmlLink"],
        event_id:     data["id"],
        organizer:    "#{data["organizer"]["displayName"]} <#{data["organizer"]["email"]}>",
        creator:      "#{data["creator"]["displayName"]} <#{data["creator"]["email"]}>",
        description:  data["description"],
        summary:      data["summary"],
        status:       data["status"],
        duration:     (end_time.to_time.utc - start_time.to_time.utc)/60
      })
    end
  end

private
  def google_api_client
    @google_client ||= Google::APIClient.new(
      :application_name => 'Ruby Calendar Stats App',
      :application_version => '1.0.0')

    @google_client.authorization = self.google_authorization

    @google_client
  end
  def google_calendar
    calendar = google_api_client.discovered_api('calendar', 'v3')
  end

end
