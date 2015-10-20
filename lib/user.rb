class User < ActiveRecord::Base
  has_many :hs_sessions
end
