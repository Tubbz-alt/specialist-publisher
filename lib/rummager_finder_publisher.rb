require "gds_api/rummager"

class RummagerFinderPublisher
  def initialize(schemas, logger: Logger.new(STDOUT))
    @schemas = schemas
    @logger = logger
  end

  def call
    schemas.each do |schema|
      if should_publish_in_this_environment?(schema)
        export_finder(schema)
      else
        logger.info("Not publishing #{schema[:file]['name']} because it is pre_production")
      end
    end
  end

private

  attr_reader :schemas, :logger

  def should_publish_in_this_environment?(schema)
    !pre_production?(schema) || SpecialistPublisher.should_publish_pre_production_finders?
  end

  def pre_production?(schema)
    schema[:file]["pre_production"] == true
  end

  def export_finder(schema)
    presenter = FinderRummagerPresenter.new(schema[:file], schema[:timestamp])

    logger.info("Publishing '#{schema[:file]['name']}' finder")

    Services.rummager.add_document(presenter.type, presenter.id, presenter.to_json)
  end
end
