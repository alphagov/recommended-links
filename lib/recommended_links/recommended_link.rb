module RecommendedLinks
  class RecommendedLink < Struct.new(:title, :description, :url, :match_phrases, :format, :section, :search_index)
    def to_index
      {
        "title"             => title,
        "description"       => description,
        "format"            => format,
        "link"              => url,
        "indexable_content" => match_phrases.join(", "),
        "section"           => section
      }
    end
  end
end
