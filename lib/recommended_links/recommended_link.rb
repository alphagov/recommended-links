module RecommendedLinks
  class RecommendedLink < Struct.new(:title, :description, :url, :match_phrases, :format, :search_index)
    def to_index
      {
        "title"             => title,
        "description"       => description,
        "format"            => format,
        "link"              => url,
        "indexable_content" => match_phrases.join(", "),
      }
    end
  end

  class DeletedLink < Struct.new(:url, :search_index)
  end
end
