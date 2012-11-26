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
      recommended_links.each do |link|
        if link.search_index.nil?
          Rummageable.index(link.to_index)
        else
          Rummageable.index(link.to_index, link.search_index)
        end
      end

      @logger.info "Recommended links indexed"
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
