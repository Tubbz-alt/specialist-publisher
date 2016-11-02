class DocumentPublisher
  def self.publish(document)
    if document.first_draft?
      document.change_note = "First published."
      document.update_type = 'major'
      document.save
    end

    Services.publishing_api.publish(document.content_id, document.update_type)

    published_document = document.class.find(document.content_id)
    indexable_document = SearchPresenter.new(published_document)

    RummagerWorker.perform_async(
      document.search_document_type,
      document.base_path,
      indexable_document.to_json,
    )

    if document.send_email_on_publish?
      EmailAlertApiWorker.perform_async(EmailAlertPresenter.new(document).to_json)
    end

    if previously_unpublished?(document)
      AttachmentRestoreWorker.perform_async(document.content_id)
    end
  end

  def self.previously_unpublished?(document)
    ordered_states = document.state_history.sort.to_h.values
    ordered_states.last(2) == %w(unpublished draft)
  end
end
