require "gds_api/publishing_api_v2"
require "gds_api/asset_manager"
require "gds_api/email_alert_api"

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(
      Plek.new.find("publishing-api"),
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"] || "example",
      timeout: 10,
    )
  end

  def self.asset_api
    @asset_api ||= GdsApi::AssetManager.new(
      Plek.current.find("asset-manager"),
      bearer_token: ENV["ASSET_MANAGER_BEARER_TOKEN"] || "12345678",
    )
  end
end
