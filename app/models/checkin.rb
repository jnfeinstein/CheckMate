class Checkin < ActiveRecord::Base
  belongs_to :user
  attr_accessible :job_id, :conf, :first, :last, :time_zone, :time
end
