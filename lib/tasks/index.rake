require_relative "../recommended_links/indexer"
require_relative "../recommended_links/parser"

namespace :rummager do
  desc "Reindex search engine"
  task :index do
    links = RecommendedLinks::Parser.parse(File.expand_path("../../data/recommended-links.csv", File.dirname(__FILE__)))
    RecommendedLinks::Indexer.new.index(links)
  end
end
