require_relative "./indexer"
require_relative "./parser"

module RecommendedLinks
  class IndexingTask
    def initialize(data_path)
      @data_path = data_path
    end
    attr_reader :data_path

    def run(indexer=RecommendedLinks::Indexer.new)
      recommended_links = []
      deleted_links = []

      Dir[File.join(data_path, "index", "*.csv")].each do |f|
        recommended_links += RecommendedLinks::Parser.new(f).links
      end

      Dir[File.join(data_path, "remove", "*.csv")].each do |f|
        deleted_links += RecommendedLinks::DeletedLinksParser.new(f).links
      end

      indexer.index(recommended_links)
      indexer.remove(deleted_links)
    end
  end
end
