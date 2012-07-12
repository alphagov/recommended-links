require_relative "recommended_link"
require 'csv'

module RecommendedLinks
  class Parser
    def initialize(filename)
      @filename = filename
      @headers = nil
      @links = nil
    end

    def links
      return @links if @links
      @links = []
      CSV.foreach(@filename, encoding: "UTF-8") do |row|
        next if row.empty? || comment?(row.first)
        if @headers
          parse_row Hash[@headers.zip(row)]
        else
          @headers = row.map(&:downcase)
        end
      end
      @links
    end

  private
    def parse_row(h)
      @links << RecommendedLink.new(
        h["title"], h["text"], h["link"],
        parse_match_phrases(h["keywords"])
      )
    end

    def parse_match_phrases(raw_match_phrases)
      raw_match_phrases.to_s.split(",").map(&:strip).reject(&:empty?)
    end

    def comment?(line)
      line =~ /^ *#/
    end
  end

  class DeletedLinksParser < Parser
    def parse_row(h)
      @links << h["link"]
    end
  end
end
