require_relative "../recommended_links/indexing_task"

namespace :rummager do
  desc "Reindex search engine"
  task :index do
    data_path = File.expand_path("../../data", File.dirname(__FILE__))
    RecommendedLinks::IndexingTask.new(data_path).run
  end
end
