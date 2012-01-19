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
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"]
      )
      Rummageable.expects(:index).with([{
          "title" => recommended_link.title,
          "description" => recommended_link.description,
          "format" => "recommended-link",
          "link" => recommended_link.url,
          "indexable_content" => recommended_link.match_phrases.join(", ")
        }]
      )
      
      Indexer.new.index([recommended_link])
    end
    
    test "Indexing multiple recommended links adds them all using rummager" do
      recommended_links = [
        RecommendedLink.new("First","","",[]),
        RecommendedLink.new("Second","","",[])
      ]
        
      Rummageable.expects(:index).with do |links|
        return false unless links.map {|l| l['title']} == %w{First Second}
        links.first.keys == %w{title description format link indexable_content}
      end
      
      Indexer.new.index(recommended_links)
    end
    
    test "Can remove links" do
      deleted = ["http://delete.me/1", "http://delete.me/2"]

      s = sequence('deletion')
      Rummageable.expects(:delete).with(deleted[0]).in_sequence(s)
      Rummageable.expects(:delete).with(deleted[1]).in_sequence(s)
      
      Indexer.new.remove(deleted)
    end
    
  end
end
