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


  def update_calendar(events=[])
    events.each do |data|
      event = Event.where(event_id: data["id"]).first || Event.new

      next unless (data["end"] and data["start"]["dateTime"])

      start_time = data["start"]["dateTime"].to_datetime
      end_time   = data["end"]["dateTime"].to_datetime

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
end
