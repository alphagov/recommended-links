require_relative "../recommended_links/indexer"
require_relative "../recommended_links/parser"

namespace :rummager do
  def data_path
    File.expand_path("../../data", File.dirname(__FILE__))
  end
  
  desc "Reindex search engine"
  task :index do
    recommended_links = []
    deleted_links = []

    Dir[File.join(data_path, "index", "*.csv")].each do |f|
      recommended_links += RecommendedLinks::Parser.new(f).recommended_links
    end

    Dir[File.join(data_path, "delete", "*.csv")].each do |f|
      deleted_links += RecommendedLinks::DeletedLinksParser.new(f).deleted_links
    end

    indexer = RecommendedLinks::Indexer.new
    indexer.index(recommended_links)
    indexer.remove(deleted_links)
  end
end
