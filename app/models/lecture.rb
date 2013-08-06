class Lecture < ActiveRecord::Base
  include Formattable
  acts_as_readable :on => :created_at
  
  attr_accessible :content, :creator, :file_upload, :title
  attr_accessible :school_day_ids, :attachment_ids, :comment_ids   # these columns do not exist in db - only for mass assign

  has_many :school_day_lectures
  has_many :school_days, :through => :school_day_lectures

  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable, :dependent => :destroy

  validates_uniqueness_of :title, :case_sensitive => false
  validates :title, :presence => true
  validates :content, :presence => true

  searchable do
    text :title, :content, :creator, :file_upload  
  end

  def print_name
    title
  end

  def print_search
    [title, content, creator, file_upload]
  end

  accepts_nested_attributes_for :comments, allow_destroy: true
end
