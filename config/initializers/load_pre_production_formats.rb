def pre_production
  pre_production_formats = []
  Dir["lib/documents/schemas/*.json"].each do |file|
    read_file = File.read(file)
    parsed_file = JSON.parse(read_file)
    if parsed_file["pre_production"]
      pre_production_formats << parsed_file["filter"]["document_type"]
    end
  end
  pre_production_formats
end

PRE_PRODUCTION = pre_production
