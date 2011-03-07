class Rating < ActiveRecord::Base
  belongs_to :rate
  belongs_to :rateable, :polymorphic => true
  
  validates_uniqueness_of :user_id, :scope => [:rateable_id, :rateable_type]

  class << self

    ##
    # Parse the specified array of [TourProduct]s in the requested format.
    #
    # === Parameters
    #
    # [rating] the array of Rating records
    # [output] the requested output format, must be :xml or :json
    #
    # @return the "ratings" in the requested structure, e.g. xml format string
    #
    def parse_as(ratings, output = :xml)
      if output == :xml
        ratings.to_xml(:only => [:user_id, :free_text], :methods => [:rate_score])
      elsif output == :json
        ratings.to_json(:only => [:user_id, :free_text], :methods => [:rate_score])
      end
    end

  end # end class methods

  ##
  # Returns this rating's rate score, e.g. 6
  #
  def rate_score
    rate.score
  end

end
