require_relative "../test_helper"
require_relative "../../lib/recommended_links/parser"

module RecommendedLinks
  class ParserTest < Test::Unit::TestCase
    test "Can parse a CSV file " do
      fixture_file = File.expand_path("../fixtures/sample.csv", File.dirname(__FILE__))
      recommended_links = Parser.new(fixture_file).recommended_links
      assert_equal 1, recommended_links.size
      assert_equal "Care homes", recommended_links.first.title
      assert_equal "Find a care home and other residential housing on the NHS Choices website", recommended_links.first.description
      assert_equal "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx", recommended_links.first.url
      assert_equal ["care homes", "old people's homes", "nursing homes", "sheltered housing"], recommended_links.first.match_phrases
    end
  end
end