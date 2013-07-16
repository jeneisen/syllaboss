class Potd < ActiveRecord::Base
  attr_accessible :name, :presentation_url, :wikipedia

  has_many :school_days

  validates_uniqueness_of :name, :case_sensitive => false
  validates :name, :presence => true


  def presentation_link
   if presentation_url[0..3] != "http"
      presentation_url.prepend("http://")
   else
      presentation_url
   end
  end

  def wikipedia_link
   if wikipedia[0..3] != "http"
      wikipedia.prepend("http://")
   else
      wikipedia
   end
  end

  def presentation_link
   if presentation_url[0..3] != "http"
      presentation_url.prepend("http://")
   else
      presentation_url
   end
  end

end
