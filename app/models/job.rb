class Job < ActiveRecord::Base
  belongs_to :repository
  
  def url
    URI.join(self.server_url+"/", "job/", self.name)
  end
end
