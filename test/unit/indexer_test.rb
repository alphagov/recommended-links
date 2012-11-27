require_relative "../test_helper"
require_relative "../../lib/recommended_links/indexer"
require 'rummageable'

module RecommendedLinks
  class IndexerTest < Test::Unit::TestCase
    test "Indexing a recommended link adds it to the search index" do
      recommended_link = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx",
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
        "recommended-link", "Business"
      )
      Rummageable.expects(:index).with([{
          "title" => recommended_link.title,
          "description" => recommended_link.description,
          "format" => recommended_link.format,
          "link" => recommended_link.url,
          "indexable_content" => recommended_link.match_phrases.join(", "),
          "section" => recommended_link.section
        }])

      Indexer.new.index([recommended_link])
    end

    test "Indexing multiple recommended links adds them all using rummager" do
      recommended_links = [
        RecommendedLink.new("First","","",[]),
        RecommendedLink.new("Second","","",[])
      ]

      Rummageable.expects(:index).with(recommended_links.map { |l| l.to_index })

      Indexer.new.index(recommended_links)
    end

    test "Can remove links" do
      deleted = [DeletedLink.new("http://delete.me/1"), DeletedLink.new("http://delete.me/2")]

      s = sequence('deletion')
      Rummageable.expects(:delete).with("http://delete.me/1").in_sequence(s)
      Rummageable.expects(:delete).with("http://delete.me/2").in_sequence(s)

      Indexer.new.remove(deleted)
    end

    test "Can add links to different indexes" do
      recommended_link = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx",
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
        "recommended-link", "Business", "test-index"
      )

      Rummageable.expects(:index).with([{
          "title" => recommended_link.title,
          "description" => recommended_link.description,
          "format" => recommended_link.format,
          "link" => recommended_link.url,
          "indexable_content" => recommended_link.match_phrases.join(", "),
          "section" => recommended_link.section
        }], '/test-index')

      Indexer.new.index([recommended_link])
    end

    test "Can remove links from different indexes" do
      deleted_link = DeletedLink.new(
        "http://example.com/delete-me",
        "test-index"
        )
      Rummageable.expects(:delete).with("http://example.com/delete-me", '/test-index')

      Indexer.new.remove([deleted_link])
    end

  end
end
