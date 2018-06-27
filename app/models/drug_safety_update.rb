class DrugSafetyUpdate < Document
  FORMAT_SPECIFIC_FIELDS = %i(
    therapeutic_area
  ).freeze

  attr_accessor(*FORMAT_SPECIFIC_FIELDS)

  def initialize(params = {})
    super(params, FORMAT_SPECIFIC_FIELDS)
  end

  def taxons
    [ALERTS_AND_RECALLS_TAXON_ID]
  end

  def self.title
    "Drug Safety Update"
  end

  def send_email_on_publish?
    false
  end

  def primary_publishing_organisation
    "240f72bd-9a4d-4f39-94d9-77235cadde8e"
  end
end
