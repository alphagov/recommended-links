require_relative "recommended_link"
require "logger"
require "plek"
require "rummageable"

DUMMY_LOGGER = Logger.new("/dev/null")

module RecommendedLinks
  class Indexer
    def initialize(logger=DUMMY_LOGGER)
      @logger = logger
    end

    def index(recommended_links)
      @logger.info "Indexing #{recommended_links.size} links..."
      to_index = recommended_links.group_by { |link| link.search_index || :default }
      to_index.each do |index, links|
        if index == :default
          index = "mainstream"
        end
        index_for(index).add_batch(links.map(&:to_index))
      end

      @logger.info "Recommended links indexed"
    end

    def remove(deleted_links)
      @logger.info "Deleting #{deleted_links.size} links..."
      deleted_links.each do |deleted_link|
        index = deleted_link.search_index
        if index.nil?
          index = "mainstream"
        end
        index_for(index).delete(deleted_link.url)
      end
      @logger.info "Links deleted"
    end

  private

    def index_for(index_name)
      @indexes ||= {}
      if @indexes[index_name].nil?
        @indexes[index_name] = Rummageable::Index.new(rummager_host, "/#{index_name}")
      end
      @indexes[index_name]
    end

    def rummager_host
      Plek.current.find('rummager')
    end
  end
end
