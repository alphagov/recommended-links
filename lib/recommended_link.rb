
class RecommendedLink
  attr_accessor :title, :description, :url, :match_phrases
  
  def initialize(title, description, url, match_phrases)
    @title = title
    @description = description
    @url = url
    @match_phrases = match_phrases
  end
end