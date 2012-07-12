require_relative "recommended_link"
require "logger"
require "rummageable"

DUMMY_LOGGER = Logger.new("/dev/null")

module RecommendedLinks
  class Indexer
    def initialize(logger=DUMMY_LOGGER)
      @logger = logger
    end

    def index(recommended_links)
      @logger.info "Indexing #{recommended_links.size} links..."
      Rummageable.index(recommended_links.map { |l| for_indexing(l) })
      @logger.info "Recommended links indexed"
    end

    def for_indexing(recommended_link)
      {
        "title" => recommended_link.title,
        "description" => recommended_link.description,
        "format" => "recommended-link",
        "link" => recommended_link.url,
        "indexable_content" => recommended_link.match_phrases.join(", ")
      }
    end

    def remove(deleted_links)
      @logger.info "Deleting #{deleted_links.size} links..."
      deleted_links.each do |deleted_link|
        Rummageable.delete(deleted_link)
      end
      @logger.info "Links deleted"
    end
  end
end
