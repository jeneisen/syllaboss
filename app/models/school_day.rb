class SchoolDay < ActiveRecord::Base
  attr_accessible :calendar_date, :ordinal, :schedule, :week, :links, :links_attributes, :comment_ids
  attr_accessible :potd_id, :link_ids, :lecture_ids, :todo_ids, :lab_ids, :homework_ids

  belongs_to :potd

  has_many :school_day_links
  has_many :links, :through => :school_day_links

  has_many :school_day_todos
  has_many :todos, :through => :school_day_todos

  has_many :school_day_labs
  has_many :labs, :through => :school_day_labs

  has_many :school_day_homeworks
  has_many :homeworks, :through => :school_day_homeworks

  has_many :school_day_lectures
  has_many :lectures, :through => :school_day_lectures

  has_many :comments, as: :commentable

  searchable do
    text :schedule, :links, :potd_id
  end  

  # validates_uniqueness_of :ordinal, :calendar_date
  validates :ordinal, :week, :calendar_date, :presence => true

  accepts_nested_attributes_for :links

  def print_name
    ordinal
  end

  def schedulize
    return [{:time => "", :stuff => ""}] if schedule.nil?

    output1 = self.schedule.split("\n").compact
    output2 = output1.collect do |row|
      # format time
      row0 = row.slice!(/^[\d:]+(AM|PM|am|pm)?\s*\-\s*[\d:]+(AM|PM|am|pm)?/) # start_time - end_time
      row0 = row0[0..-2] if !row0.nil? && row0[-1] == ":"

      # find stuff
      row.slice!(/^(\s?\-|:?)/)
      
      if !row0.nil?
        {:time => row0, :stuff => row}
      else
        {:time => "", :stuff => row}
      end
    end

    output2.each_with_index do |row, index|   
      if row[:time] != ""
        @row_with_time = row 
      elsif row[:time] == "" && !row.nil?
        @row_with_time[:stuff] << " #{row[:stuff]}"
      end
    end

    output2.delete_if {|row| row[:time].empty?}
  end

  def read_schedule
    schedulize.each do |item|
      read_time(item[:time])
      read_stuff(item[:stuff])
    end
  end

  def read_time
  end

  def read_stuff
  end
  
end

