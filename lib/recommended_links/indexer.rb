require_relative "recommended_link"

module RecommendedLinks
  class Indexer
    def index(recommended_links)
      Rummageable.index([*recommended_links].map { |l| for_indexing(l) })
    end
    
    def for_indexing(recommended_link)
      {
        "title" => recommended_link.title,
        "description" => recommended_link.description,
        "format" => "recommended-link",
        "link" => recommended_link.url,
        "indexable_content" => recommended_link.match_phrases.join(" ")
      }      
    end
  end
end