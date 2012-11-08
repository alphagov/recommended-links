require_relative "../test_helper"
require "recommended_links/indexing_task"

module RecommendedLinks
  class RakeTaskTest < Test::Unit::TestCase
    test "rake rummager:index parses" do
      indexer = stub_everything("Indexer")

      recommended_link = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx",
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
        "recommended-link"
      )
      indexer.expects(:index).with([recommended_link])
      indexer.expects(:remove).with(["http://delete.me/some/page.html"])

      data_path = File.expand_path("../../fixtures/data", __FILE__)
      IndexingTask.new(data_path).run(indexer)
    end

    def teardown
      Rake.application = nil
    end
  end
end
