require_relative "recommended_link"
require 'csv'

module RecommendedLinks
  class Parser
    def initialize(filename)
      @filename = filename
      @state = :initial
      @recommended_links = []
    end

    def recommended_links
      CSV.foreach(@filename) { |row| parse_row(row) }
      @recommended_links
    end

    def parse_row(row)
      self.send(:"parse_#{@state}_row", row)
    end
  
    def parse_initial_row(row)
      if header_row?(row)
        @header = row
        @state = :body
      end
    end
  
    def header_row?(row)
      row.reject {|cell| cell.strip.size == 0}.size >= 4
    end
  
    def parse_body_row(row)
      need_id, title, description, url, raw_match_phrases = row
    
      @recommended_links << 
        RecommendedLink.new(title, description, url, parse_match_phrases(raw_match_phrases))
    end
  
    def parse_match_phrases(raw_match_phrases)
      raw_match_phrases.split(",").map { |phrase| phrase.strip }.reject { |phrase| phrase.size == 0}
    end
  
  end
end