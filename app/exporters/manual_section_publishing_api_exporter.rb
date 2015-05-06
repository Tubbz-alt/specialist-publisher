class ManualSectionPublishingAPIExporter

  def initialize(export_recipent, organisations_api, document_renderer, manual, document)
    @export_recipent = export_recipent
    @organisations_api = organisations_api
    @document_renderer = document_renderer
    @manual = manual
    @document = document
  end

  def call
    export_recipent.put_content_item(base_path, exportable_attributes)
  end

private

  attr_reader :export_recipent, :document_renderer, :organisations_api, :manual, :document

  def base_path
    "/#{rendered_document_attributes.fetch(:slug)}"
  end

  def exportable_attributes
    {
      format: "manual_section",
      title: rendered_document_attributes.fetch(:title),
      description: rendered_document_attributes.fetch(:summary),
      public_updated_at: rendered_document_attributes.fetch(:updated_at),
      update_type: update_type,
      publishing_app: "specialist-publisher",
      rendering_app: "manuals-frontend",
      routes: [
        {
          path: base_path,
          type: "exact",
        }
      ],
      details: {
        body: rendered_document_attributes.fetch(:body),
        manual: {
          base_path: "/#{manual.attributes.fetch(:slug)}",
        },
        organisations: [
          organisation_info
        ],
      }
    }
  end

  def update_type
    document.minor_update? ? "minor" : "major"
  end

  def rendered_document_attributes
    @rendered_document_attributes ||= document_renderer.call(document).attributes
  end

  def organisation_info
    {
      title: organisation.title,
      abbreviation: organisation.details.abbreviation,
      web_url: organisation.web_url,
    }
  end

  def organisation
    @organisation ||= organisations_api.organisation(manual.attributes.fetch(:organisation_slug))
  end
end
