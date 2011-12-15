require_relative "../recommended_links/indexer"
require_relative "../recommended_links/parser"

namespace :rummager do
  desc "Reindex search engine"
  task :index do
    parser = RecommendedLinks::Parser.new(File.expand_path("../../data/recommended-links.csv", File.dirname(__FILE__)))
    RecommendedLinks::Indexer.new.index(parser.recommended_links)
  end
end
