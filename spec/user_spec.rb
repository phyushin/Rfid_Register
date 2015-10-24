require "user"

RSpec.describe User do
  it "creates a user if they don't exist" do
    uid = "123456"
    User.process_uid(uid)

    user = User.find_by(uid: uid)
    expect(user.uid).to eq(uid)
  end

  describe "when the user is not signed in" do
    it "creates a new session" do
      user = User.create(uid: "123456")
      user.process_session

      expect(user.hs_sessions.count).to eq(1)
    end
  end

  describe "when the user is signed in" do
    it "signs_out_the_user" do
      user = User.create(uid: "123456")
      user.hs_sessions.create(timein: Time.now)
      user.process_session

      expect(user.hs_sessions.last.timeout).not_to be_nil
    end
  end
end
