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

      recommended_link_types = Dir.glob(File.join(data_path, "index", "**")).select { |f| File.directory?(f) }
      recommended_link_types.each do |path|
        type = path.split("/")[-1]
        Dir[File.join(path, "*.csv")].each do |f|
          recommended_links += RecommendedLinks::Parser.new(f, type).links
        end
      end

      Dir[File.join(data_path, "remove", "*.csv")].each do |f|
        deleted_links += RecommendedLinks::DeletedLinksParser.new(f).links
      end

      indexer.index(recommended_links)
      indexer.remove(deleted_links)
    end
  end
end
