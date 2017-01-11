class Rack::Attack
  # Throttle definitions below are derived from:
  #   https://github.com/kickstarter/rack-attack/wiki/Example-Configuration

  ### Throttle spammy clients ###

  # Throttle all requests by IP (60rpm).
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip 
  end

  ### Prevent Brute-Force login attacks ###

  # Throttle POST requests to /session by IP address (15rpm).
  throttle("sessions/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/session" && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /session by email param (15rpm).
  throttle("sessions/email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/session" && req.post?
      req.params[:email].presence
    end
  end
end
