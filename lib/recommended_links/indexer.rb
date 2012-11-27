require_relative "recommended_link"
require "logger"
require "rummageable"

DUMMY_LOGGER = Logger.new("/dev/null")

module RecommendedLinks
  class Indexer
    def initialize(logger=DUMMY_LOGGER)
      @logger = logger
    end

    def DEFAULT_ALIAS
      "DEFAULT_INDEX"
    end

    def index(recommended_links)
      @logger.info "Indexing #{recommended_links.size} links..."
      to_index = {}
      recommended_links.each do |link|
        (to_index[link.search_index || self.DEFAULT_ALIAS] ||= []) << link
      end
      to_index.each do |index, links|
        if index == self.DEFAULT_ALIAS
          Rummageable.index(links.map { |l| l.to_index })
        else
          Rummageable.index(links.map { |l| l.to_index }, "/#{index}")
        end
      end

      @logger.info "Recommended links indexed"
    end

    def remove(deleted_links)
      @logger.info "Deleting #{deleted_links.size} links..."
      deleted_links.each do |deleted_link|
        if deleted_link.search_index.nil?
          Rummageable.delete(deleted_link.url)
        else
          Rummageable.delete(deleted_link.url, "/#{deleted_link.search_index}")
        end
      end
      @logger.info "Links deleted"
    end
  end
end
