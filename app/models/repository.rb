class Repository < ActiveRecord::Base
  def self.exists?(id)
    find =  Repository.find_by_id id
    find != nil
  end
end