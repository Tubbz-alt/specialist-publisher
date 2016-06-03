module PublishingApiHelpers
  def write_payload(document)
    document.delete("updated_at")
    document.delete("publication_state")
    document.delete("first_published_at")
    document.delete("public_updated_at")
    document
  end

  def saved_for_the_first_time(document)
    document.deep_merge(
      "details" => {
        "change_history" => [
          {
            "public_timestamp" => STUB_TIME_STAMP,
            "note" => "First published.",
          }
        ]
      }
    )
  end
end

RSpec.configuration.include PublishingApiHelpers
