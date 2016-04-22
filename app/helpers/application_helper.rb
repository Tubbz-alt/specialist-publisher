module ApplicationHelper
  def facet_options(form, facet)
    form.object.facet_options(facet)
  end

  def content_preview_url(document)
    Plek.current.find("draft-origin") + document.base_path
  end

  def published_document_path(document)
    Plek.current.find("website-root") + document.base_path
  end

  def state(document)
    state = document.live? ? "published" : document.publication_state

    if document.draft?
      classes = "label label-primary"
    else
      classes = "label label-default"
    end

    content_tag(:span, state, class: classes).html_safe
  end
end
