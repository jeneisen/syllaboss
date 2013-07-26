class Link < ActiveRecord::Base
  include Formattable

  attr_accessible :description, :link_url, :title, :name, :school_day_ids, :comment_ids

  has_many :school_day_links
  has_many :school_days, :through => :school_day_links
  
  has_many :comments, as: :commentable

  searchable do
    text :link_url, :title, :description
  end

  def print_name
  	title
  end
end


