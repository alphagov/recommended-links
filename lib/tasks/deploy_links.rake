require "logger"
require_relative "../recommended_links/indexing_task"

desc "Deploy the recommended links to rummager and external link tracker"
task :deploy_links do
  logger = Logger.new(Rake.verbose ? STDERR : "/dev/null")
  logger.formatter = Proc.new do |severity, datetime, progname, msg|
    "[#{severity}] #{msg}\n"
  end

  data_path = File.expand_path("../../data", File.dirname(__FILE__))

  indexer = RecommendedLinks::Indexer.new(logger)
  registerer = RecommendedLinks::ExternalLinkRegisterer.new(logger)

  RecommendedLinks::IndexingTask.new(data_path,
                                     indexer: indexer,
                                     external_link_registerer: registerer).run
end
