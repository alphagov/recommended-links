require_relative "../test_helper"
require 'rake'

module RecommendedLinks
  class RakeTaskTest < Test::Unit::TestCase
    def setup
      Rake.application = Rake::Application.new
      load File.dirname(__FILE__) + '/../../lib/tasks/index.rake'
    end
    
    test "rake rummager:index parses" do
      indexer = stub_everything("Indexer")
      RecommendedLinks::Indexer.stubs(:new).returns(indexer)
      recommended_links_parser = stub("Recommended links parser", recommended_links: [])
      RecommendedLinks::Parser.expects(:new).with(regexp_matches /recommended-links.csv$/).returns(recommended_links_parser)
      deleted_links_parser = stub("Deleted links parser", deleted_links: ["http://delete.me"])
      RecommendedLinks::DeletedLinksParser.expects(:new).with(regexp_matches /deleted-links.txt$/).returns(deleted_links_parser)

      indexer.expects(:index).with(recommended_links_parser.recommended_links)
      indexer.expects(:remove).with(deleted_links_parser.deleted_links)

      Rake.application["rummager:index"].invoke
    end
    
    def teardown
      Rake.application = nil
    end
  end
end