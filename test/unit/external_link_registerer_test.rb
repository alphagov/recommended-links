require 'gds_api/external_link_tracker'
require_relative "../test_helper"
require_relative "../../lib/recommended_links/external_link_registerer"

module RecommendedLinks
  class ExternalLinkRegistererTest < Test::Unit::TestCase
    test "#register sends links to the external link tracker" do
      care_homes_url = "http://www.nhs.uk/CarersDirect/guide/practicalsupport/Pages/Carehomes.aspx"
      care_homes = RecommendedLink.new(
        "Care homes",
        "Find a care home and other residential housing on the NHS Choices website",
        care_homes_url,
        ["care homes", "old people's homes", "nursing homes", "sheltered housing"],
      )

      nhs_choices_url = "http://www.nhs.uk/"
      nhs_choices = RecommendedLink.new(
        "NHS Choices",
        "Information from the National Health Service on conditions, treatments, local services and healthy living",
        nhs_choices_url,
        ["nhs", "health"],
      )

      GdsApi::ExternalLinkTracker.any_instance
                                 .expects(:add_external_link)
                                 .with(care_homes_url)

      GdsApi::ExternalLinkTracker.any_instance
                                 .expects(:add_external_link)
                                 .with(nhs_choices_url)

      ExternalLinkRegisterer.new.register_links([care_homes, nhs_choices])
    end
  end
end
