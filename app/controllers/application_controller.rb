class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods

  before_filter :require_signin_permission!

  helper_method :current_format
  helper_method :formats_user_can_access

private

  def current_format
    document_types.fetch(params.fetch(:document_type, nil), nil)
  end

  def formats_user_can_access
    if current_user.gds_editor?
      document_types
    else
      Hash(document_types.select { |k, v| v.organisations.include?(current_user.organisation_content_id) })
    end
  end

  # This Struct is for the document_types method below
  FormatStruct = Struct.new(:klass, :document_type, :format_name, :title, :organisations)

  def document_types
    # For each format that follows the standard naming convention, this
    # method takes the title and name of the model class of each format
    # like this:
    #
    # data = {
    #   "GDS Report" => GdsReport
    # }
    #
    # which will become this:
    #
    # {
    #   "gds-reports" => FormatStruct.new(
    #     klass: GdsReports
    #     document_type: "gds-reports",
    #     format_name: "gds_report",
    #     title: "GDS Report",
    #     organisations: ["a-content-id"],
    #   )
    # }

    data = {
      "AAIB Report" => AaibReport,
      "CMA Case" => CmaCase,
      "RAIB Report" => RaibReport,
    }

    data.map do |k, v|
      {
        k.downcase.parameterize.pluralize => FormatStruct.new(
          v,
          k.downcase.parameterize.pluralize,
          k.downcase.parameterize.underscore,
          k,
          v.organisations,
        )
      }
    end.reduce({}, :merge)
  end

end
