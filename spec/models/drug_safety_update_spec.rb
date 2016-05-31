require 'spec_helper'
require 'models/valid_against_schema'

RSpec.describe DrugSafetyUpdate do
  let(:payload) { FactoryGirl.create(:drug_safety_update) }
  include_examples "it saves payloads that are valid against the 'specialist_document' schema"

  context "#publish!" do
    let(:payload) {
      FactoryGirl.create(:drug_safety_update,
        update_type: "major",
        publication_state: "draft")
    }
    let(:document) { described_class.from_publishing_api(payload) }

    it "doesn't notify the Email Alert API on major updates" do
      publishing_api_has_item(payload)
      stub_publishing_api_publish(payload["content_id"], {})
      stub_any_rummager_post_with_queueing_enabled

      document.publish!

      assert_publishing_api_publish(payload["content_id"])
      assert_not_requested(:post, Plek.current.find('email-alert-api') + "/notifications")
    end
  end
end
