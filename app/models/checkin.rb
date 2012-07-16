class Checkin < ActiveRecord::Base
  belongs_to :user
  attr_accessible :conf, :first, :last, :time
end
