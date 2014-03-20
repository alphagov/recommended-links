require_relative "./indexer"
require_relative "./parser"
require_relative "./external_link_registerer"

module RecommendedLinks
  class IndexingTask
    attr_reader :data_path, :indexer, :external_link_registerer

    def initialize(data_path, options = {})
      @data_path = data_path
      @indexer = options[:indexer]
      @external_link_registerer = options[:external_link_registerer]
    end

    def run
      if indexer
        indexer.index(recommended_links)
        indexer.remove(deleted_links)
      end

      if external_link_registerer
        external_link_registerer.register_links(recommended_links)
      end
    end

  private
    def recommended_links
      @recommended_links ||= recommended_link_types.flat_map do |type|
        path = File.join(recommended_links_path, type)
        csv_files(path).flat_map do |file|
          RecommendedLinks::Parser.new(file, type).links
        end
      end
    end

    def deleted_links
      @deleted_links ||= csv_files(deleted_links_path).flat_map do |file|
        RecommendedLinks::DeletedLinksParser.new(file).links
      end
    end

    def recommended_links_path
      File.join(data_path, "index")
    end

    def deleted_links_path
      File.join(data_path, "remove")
    end

    def recommended_link_types
      directories(recommended_links_path)
    end

    def directories(path)
      Dir.entries(path).reject { |file| file =~ /^\./ }.select do |file|
        File.directory?(File.join(path, file))
      end
    end

    def csv_files(path)
      Dir.glob(File.join(path, "*.csv"))
    end
  end
end
