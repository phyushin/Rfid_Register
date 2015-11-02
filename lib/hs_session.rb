class HsSession < ActiveRecord::Base
  belongs_to :user

  def self.session_length(user)
    session = user.hs_sessions.last
    duration = ((session.timeout - session.timein) / 1.hour).round(2)
    session.update_attribute(:diff, duration)
  end
end
