require_relative "../test_helper"
require "recommended_links/indexing_task"

module RecommendedLinks
  class RakeTaskTest < Test::Unit::TestCase
    test "rake rummager:index parses" do
      indexer = stub_everything("Indexer")

      expected_recommended_link = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx",
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
        "recommended-link", "This is a section"
      )
      expected_deleted_link = DeletedLink.new(
        "http://delete.me/some/page.html"
      )
      indexer.expects(:index).with([expected_recommended_link])
      indexer.expects(:remove).with([expected_deleted_link])

      data_path = File.expand_path("../../fixtures/data", __FILE__)
      IndexingTask.new(data_path, indexer: indexer).run
    end

    def teardown
      Rake.application = nil
    end
  end
end
