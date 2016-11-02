class CmaCase < Document
  validates :opened_date, allow_blank: true, date: true, open_before_closed: true
  validates :market_sector, presence: true
  validates :case_type, presence: true
  validates :case_state, presence: true
  validates :closed_date, allow_blank: true, date: true

  FORMAT_SPECIFIC_FIELDS = %i(
    opened_date
    closed_date
    case_type
    case_state
    market_sector
    outcome_type
  ).freeze

  attr_accessor(*FORMAT_SPECIFIC_FIELDS)

  def initialize(params = {})
    super(params, FORMAT_SPECIFIC_FIELDS)
  end

  def self.title
    "CMA Case"
  end
end
