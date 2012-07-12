require "logger"
require_relative "../recommended_links/indexing_task"

namespace :rummager do
  desc "Reindex search engine"
  task :index do
    logger = Logger.new(Rake.verbose ? STDERR : "/dev/null")
    logger.formatter = Proc.new do |severity, datetime, progname, msg|
      "[#{severity}] #{msg}\n"
    end
    data_path = File.expand_path("../../data", File.dirname(__FILE__))
    indexer = RecommendedLinks::Indexer.new(logger)
    RecommendedLinks::IndexingTask.new(data_path).run(indexer)
  end
end
