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
      stub_index = stub("Rummageable::Index")
      Rummageable::Index.expects(:new).returns(stub_index)
      stub_index.expects(:add_batch).with([{
          "title" => recommended_link.title,
          "description" => recommended_link.description,
          "format" => recommended_link.format,
          "link" => recommended_link.url,
          "indexable_content" => recommended_link.match_phrases.join(", "),
        }])

      Indexer.new.index([recommended_link])
    end

    test "Indexing multiple recommended links adds them all using rummager" do
      recommended_links = [
        RecommendedLink.new("First","","",[]),
        RecommendedLink.new("Second","","",[])
      ]

      stub_index = stub("Rummageable::Index")
      Rummageable::Index.expects(:new).returns(stub_index)
      stub_index.expects(:add_batch).with(recommended_links.map { |l| l.to_index })

      Indexer.new.index(recommended_links)
    end

    test "Can remove links" do
      deleted = [DeletedLink.new("http://delete.me/1"), DeletedLink.new("http://delete.me/2")]

      s = sequence('deletion')
      stub_index = stub("Rummageable::Index")
      Rummageable::Index.expects(:new).with('http://rummager.dev.gov.uk', '/mainstream').returns(stub_index)
      stub_index.expects(:delete).with("http://delete.me/1").in_sequence(s)
      stub_index.expects(:delete).with("http://delete.me/2").in_sequence(s)

      Indexer.new.remove(deleted)
    end

    test "Can add links to different indexes" do
      recommended_link = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx",
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
        "recommended-link", "test-index"
      )

      stub_index = stub("Rummageable::Index")
      Rummageable::Index.expects(:new).with('http://rummager.dev.gov.uk', '/test-index').returns(stub_index)
      stub_index.expects(:add_batch).with([{
          "title" => recommended_link.title,
          "description" => recommended_link.description,
          "format" => recommended_link.format,
          "link" => recommended_link.url,
          "indexable_content" => recommended_link.match_phrases.join(", "),
        }])

      Indexer.new.index([recommended_link])
    end

    test "Can remove links from different indexes" do
      deleted_link = DeletedLink.new(
        "http://example.com/delete-me",
        "test-index"
        )

      stub_index = stub("Rummageable::Index")
      Rummageable::Index.expects(:new).with('http://rummager.dev.gov.uk', '/test-index').returns(stub_index)
      stub_index.expects(:delete).with("http://example.com/delete-me")

      Indexer.new.remove([deleted_link])
    end

  end
end
