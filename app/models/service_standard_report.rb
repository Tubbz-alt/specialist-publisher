class ServiceStandardReport < Document
  FORMAT_SPECIFIC_FIELDS = %i(
    assessment_date
    result
    service_provider
    stage
  ).freeze

  attr_accessor(*FORMAT_SPECIFIC_FIELDS)

  def initialize(params = {})
    super(params, FORMAT_SPECIFIC_FIELDS)
  end

  def taxons
    [DIGITAL_SERVICE_STANDARD_TAXON_ID]
  end

  def self.title
    "Service Standard Report"
  end

  def primary_publishing_organisation
    "af07d5a5-df63-4ddc-9383-6a666845ebe9"
  end
end
