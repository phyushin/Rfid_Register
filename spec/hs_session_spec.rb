require "hs_session"

RSpec.describe HsSession do
  it "creates a time diff on sign out" do
    time_in = Time.local(2015, 10, 1, 8, 0, 0)

    [4.hours, 0.5.hours, 3.5.hours, 0.25.hours].each do |time|
      uid = (0...50).map { ('0'..'9').to_a[rand(26)] }.join

      Timecop.freeze(time_in) do
        User.process_uid(uid)
      end

      user = User.find_by(uid: uid)
      @uid_new = (uid.to_i + 1).to_s

      Timecop.freeze(time_in + time) do
        user.process_session
      end

      session = user.hs_sessions.last

      expect(session.diff).to eq((time / 1.hour).round(2))
    end
  end
end
