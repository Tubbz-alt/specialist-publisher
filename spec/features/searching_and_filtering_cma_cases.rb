require 'spec_helper'

RSpec.feature "Searching and filtering", type: :feature do
  let(:fields) { [:base_path, :content_id, :public_updated_at, :title, :publication_state] }

  let(:cma_cases) {
    ten_example_cases = 10.times.collect do |n|
      Payloads.cma_case_content_item(
        "title" => "Example CMA Case #{n}",
        "description" => "This is the summary of example CMA case #{n}",
        "base_path" => "/cma-cases/example-cma-case-#{n}",
        "publication_state" => "draft",
      )
    end
    ten_example_cases[1]["publication_state"] = "live"
    ten_example_cases
  }

  let(:page_number) { 1 }
  let(:per_page) { 50 }

  before do
    log_in_as_editor(:cma_editor)
  end

  context "visiting the index" do
    before do
      publishing_api_has_content(cma_cases, document_type: CmaCase.publishing_api_document_type, fields: fields, page: page_number, per_page: per_page)
    end

    scenario "viewing the unfiltered items" do
      visit "/cma-cases"

      expect(page.status_code).to eq(200)
      expect(page).to have_selector('li.document', count: 10)
      expect(page).to have_content("Example CMA Case 0")
      expect(page).to have_content("Example CMA Case 1")
      expect(page).to have_content("Example CMA Case 2")
      within(".document-list li.document:nth-child(2)") do
        expect(page).to have_content("published")
      end
    end

    scenario "filtering the items with some results returned" do
      publishing_api_has_content([cma_cases.first], document_type: CmaCase.publishing_api_document_type, fields: fields, page: page_number, per_page: per_page, q: "0")

      visit "/cma-cases"

      fill_in "Search", with: "0"
      click_button "Search"
      expect(page).to have_content("Example CMA Case 0")
      expect(page).to have_selector('li.document', count: 1)
    end

    scenario "filtering the items with no results returned" do
      publishing_api_has_content([], document_type: CmaCase.publishing_api_document_type, fields: fields, page: page_number, per_page: per_page, q: "abcdef")

      visit "/cma-cases"
      fill_in "Search", with: "abcdef"
      click_button "Search"
      expect(page).to have_content("Your search – abcdef – did not match any documents.")
    end
  end
end
