class Lecture < ActiveRecord::Base
  include Formattable
  
  attr_accessible :content, :creator, :file_upload, :title
  attr_accessible :school_day_ids, :attachment_ids, :comment_ids   # these columns do not exist in db - only for mass assign

  has_many :school_day_lectures
  has_many :school_days, :through => :school_day_lectures

  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable

  searchable do
    text :title, :content  
  end

  accepts_nested_attributes_for :comments, allow_destroy: true
end
