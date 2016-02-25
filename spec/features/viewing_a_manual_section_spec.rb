require 'spec_helper'

RSpec.feature "Viewing a Manual and its Sections", type: :feature do

  context 'as a GDS editor' do
    def manual_content_item
      {
        "base_path" => "/guidance/a-manual",
        "content_id" => "b1dc075f-d946-4bcb-a5eb-941f8c8188cf",
        "description" => "A manual description",
        "details" => {
          "body" => "A manual body",
          "child_section_groups" => [
            {
              "title" => "Contents",
              "child_sections" => [
                {
                  "title" => "First section",
                  "description" => "This is a manual's first section",
                  "base_path" => "/guidance/a-manual/first-section"
                },
                {
                  "title" => "Second section",
                  "description" => "This is a manual's second section",
                  "base_path" => "/guidance/a-manual/second-section"
                },
              ]
            }
          ],
          "change_notes" => [
            {
              "base_path" => "/guidance/a-manual/first-section",
              "title" => "First section",
              "change_note" => "New section added.",
              "published_at" => "2015-12-23T14:38:51+00:00"
            },
            {
              "base_path" => "/guidance/a-manual/second-section",
              "title" => "Second section",
              "change_note" => "New section added.",
              "published_at" => "2015-12-23T14:38:51+00:00"
            },
          ],
          "organisations" => [
            {
              "title" => "Goverment Digital Service",
              "abbreviation" => "GDS",
              "web_url" => "https://www.gov.uk/government/organisations/government-digital-service"
            }
          ]
        },
        "format" => "manual",
        "locale" => "en",
        "public_updated_at" => "2016-02-02T12:28:41.000Z",
        "publishing_app" => "specialist-publisher",
        "redirects" => [],
        "rendering_app" => "manuals-frontend",
        "routes" => [
          {
            "path" => "/guidance/a-manual",
            "type" => "exact"
          },
          {
            "path" => "/guidance/a-manual/updates",
            "type" => "exact"
          }
        ],
        "title" => "A Manual",
        "analytics_identifier" => nil,
        "phase" => "live",
        "update_type" => "major",
        "need_ids" => [],
        "publication_state" => "live",
        "live_version" => 2,
        "version" => 2
      }
    end

    def manual_links
      {
        "content_id" => "b1dc075f-d946-4bcb-a5eb-941f8c8188cf",
        "links" => {
          "sections" => [
            "f12895fc-58d8-417a-a762-2a5fb2266d63",
            "7df32e1b-d92c-4e63-8c74-7922c408cfd5",
          ],
          "organisations" => [
            "af07d5a5-df63-4ddc-9383-6a666845ebe9"
          ]
        }
      }
    end

    def section_content_items
      [
        {
          "base_path" => "/guidance/a-manual/first-section",
          "content_id" => "7df32e1b-d92c-4e63-8c74-7922c408cfd5",
          "description" => "This is a manual's first section",
          "details" => {
            "body" => "First section body",
            "organisations" => [
              {
                "title" => "Goverment Digital Service",
                "abbreviation" => "DVSA",
                "web_url" => "https://www.gov.uk/government/organisations/government-digital-service"
              }
            ]
          },
          "format" => "manual_section",
          "locale" => "en",
          "public_updated_at" => "2016-02-02T12:28:41.000Z",
          "publishing_app" => "specialist-publisher",
          "redirects" => [],
          "rendering_app" => "manuals-frontend",
          "routes" => [
            {
              "path" => "/guidance/a-manual/first-section",
              "type" => "exact"
            }
          ],
          "title" => "First section",
          "analytics_identifier" => nil,
          "phase" => "live",
          "update_type" => "major",
          "need_ids" => [],
          "publication_state" => "live",
          "live_version" => 2,
          "version" => 2
        },
        {
          "base_path" => "/guidance/a-manual/second-section",
          "content_id" => "f12895fc-58d8-417a-a762-2a5fb2266d63",
          "description" => "This is a manual's second section",
          "details" => {
            "body" => "Second section body",
            "organisations" => [
              {
                "title" => "Goverment Digital Service",
                "abbreviation" => "DVSA",
                "web_url" => "https://www.gov.uk/government/organisations/government-digital-service"
              }
            ]
          },
          "format" => "manual_section",
          "locale" => "en",
          "public_updated_at" => "2016-02-02T12:28:41.000Z",
          "publishing_app" => "specialist-publisher",
          "redirects" => [],
          "rendering_app" => "manuals-frontend",
          "routes" => [
            {
              "path" => "/guidance/a-manual/second-section",
              "type" => "exact"
            }
          ],
          "title" => "Second section",
          "analytics_identifier" => nil,
          "phase" => "live",
          "update_type" => "major",
          "need_ids" => [],
          "publication_state" => "live",
          "live_version" => 2,
          "version" => 2
        },
      ]
    end

    def section_links
      [
        {
          "content_id" => "7df32e1b-d92c-4e63-8c74-7922c408cfd5",
          "links" => {
            "manual" => [
              "b1dc075f-d946-4bcb-a5eb-941f8c8188cf"
            ],
            "organisations" => [
              "af07d5a5-df63-4ddc-9383-6a666845ebe9"
            ]
          }
        },
        {
          "content_id" => "f12895fc-58d8-417a-a762-2a5fb2266d63",
          "links" => {
            "manual" => [
              "b1dc075f-d946-4bcb-a5eb-941f8c8188cf"
            ],
            "organisations" => [
              "af07d5a5-df63-4ddc-9383-6a666845ebe9"
            ]
          }
        }
      ]
    end

    before do
      log_in_as_editor(:gds_editor)

      publishing_api_has_fields_for_format("manual", [manual_content_item], [:content_id])
      publishing_api_has_fields_for_format("manual_section", section_content_items.map { |section| { content_id: section["content_id"] } }, [:content_id])

      content_items = [manual_content_item] + section_content_items

      content_items.each do |payload|
        publishing_api_has_item(payload)
      end

      links = [manual_links] + section_links

      links.each do |link_set|
        publishing_api_has_links(link_set)
      end
    end

    scenario "from the index" do
      visit "/manuals"

      expect(page.status_code).to eq(200)
      expect(page).to have_content("A Manual")

      click_link "A Manual"

      expect(page.status_code).to eq(200)
      expect(page).to have_content("First section")
      expect(page).to have_content("Second section")
    end

    scenario "viewing a Section" do
      visit "/manuals/#{manual_content_item["content_id"]}"

      expect(page.status_code).to eq(200)
      expect(page).to have_content("First section")

      click_link "First section"

      expect(page.status_code).to eq(200)
      expect(page).to have_content("This is a manual's first section")
    end

    scenario "requesting a Section with the wrong content id" do
      invalid_content_id = SecureRandom.uuid
      publishing_api_does_not_have_item(invalid_content_id)

      visit "/manuals/#{manual_content_item["content_id"]}/sections/#{invalid_content_id}"

      expect(current_path).to eq(manuals_path)
      expect(page).to have_content "Section not found"
    end

    scenario "requesting a Section with the wrong manual content id" do
      visit "/manuals/#{SecureRandom.uuid}/sections/#{section_content_items.first["content_id"]}"

      expect(page.current_path).to eq(manuals_path)
      expect(page).to have_content "Section does exist, but not within the supplied manual"
    end
  end
end
