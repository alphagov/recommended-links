require_relative "../recommended_links/indexer"
require_relative "../recommended_links/parser"

namespace :rummager do
  def data_file(filename)
    File.expand_path("../../data/#{filename}", File.dirname(__FILE__))
  end
  
  desc "Reindex search engine"
  task :index do
    recommended_links = RecommendedLinks::Parser.new(data_file("recommended-links.csv")).recommended_links
    deleted_links = RecommendedLinks::DeletedLinksParser.new(data_file("deleted-links.txt")).deleted_links
    indexer = RecommendedLinks::Indexer.new
    indexer.index(recommended_links)
    indexer.remove(deleted_links)
  end
end
