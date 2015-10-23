class User < ActiveRecord::Base
  has_many :hs_sessions

  def self.process_uid(uid)
    user = User.find_by(uid: uid)
    user.nil? ? create_user(uid) : user.process_session
  end

  def self.create_user(uid)
    puts "creating user"
    User.create(uid: uid)
  end

  def process_session
    puts "Processing session"
    if hs_sessions.empty? || hs_sessions.last.timeout?
      create_new_session
    else
      sign_out_user
    end
  end

  private

  def create_new_session
    hs_sessions.create(timein: Time.now)
    puts "Signed in"
  end

  def sign_out_user
    hs_sessions.last.update_attribute(:timeout, Time.now)
    puts "Signed out"
    work_out_diff
  end

  def work_out_diff
    ##### TODO #####
    true
  end
end
