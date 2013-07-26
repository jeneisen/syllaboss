class Lab < ActiveRecord::Base
  include Formattable
  
  attr_accessible :lab_url, :name, :school_day_ids, :comment_ids

  has_many :school_day_labs
  has_many :school_days, :through => :school_day_labs

  has_many :comments, as: :commentable

  def title
    name
  end

  searchable do
    text :name, :lab_url  
  end

  def print_name
  	name
  end
end
