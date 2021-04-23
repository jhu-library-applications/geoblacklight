require "application_system_test_case"

class ShowPageTest < ApplicationSystemTestCase
  def setup
  end

  def test_basic_dom
    visit "/catalog/stanford-cz128vq0535"

    assert page.has_selector?("header#topnav")              # JHU Branding
    assert page.has_selector?("nav#header-navbar")          # Static Pages
    assert page.has_selector?("nav#search-navbar")          # Search Form
    assert page.has_selector?("div#main-container")         # Main
    assert page.has_selector?("[data-analytics-id]")        # Google Analytics
    within("div#main-container") do
      assert page.has_selector?("section.show-document")    # Document
    end
    within("section.show-document") do
      assert page.has_selector?("div#document")
    end
    within("section.show-document") do
      assert page.has_selector?("h2")                       # Title
      assert page.has_selector?("dl.document-metadata")     # Metadata
      assert page.has_selector?("div#viewer-container")     # Viewer
    end
    within("div#viewer-container") do
      assert page.has_selector?("h3.help-text")             # Help Text
      assert page.has_selector?("div#map")                  # Map
    end
    assert page.has_selector?("section.page-sidebar")       # Sidebar
    within("section.page-sidebar") do
      assert page.has_selector?("div.show-tools")           # Tools
      assert page.has_selector?("div.downloads")            # Downloads
      assert page.has_selector?("div.exports")              # Exports
    end
    assert page.has_selector?("footer")                     # Footer
  end

  def test_show_page_search_nav
    visit '/?utf8=✓&q=&search_field=all_fields'
    within("div#documents") do
      find("a", match: :first).click
    end

    assert page.has_selector?('div.pagination-search-widgets')
    within("div.pagination-search-widgets") do
      assert page.has_link?("Start over")                    # Start over
      assert page.has_link?("Back to search")                # Back to search
      assert page.has_selector?("div.page-links")            # Pagination
    end
  end

  def test_show_geom_type_icon
    visit '/catalog/99-0001-test'

    within("div.document") do
      assert page.has_selector?("span.blacklight-icon-table")# Table icon
    end
  end

  def test_show_page_relations_link
    # JHU Atlas Fixture
    visit "/catalog/hopkins-912X14FOLIOc1-35326-27"

    # Browse Relations
    click_link("Browse all 28 records...")
    within("span.page-entries") do
      assert page.has_content?("28")
    end
  end

  def test_show_page_collection_link
    # JHU Atlas Fixture
    visit "/catalog/hopkins-912X14FOLIOc1-35326-27"

    # Collection Link
    click_link("hopkins-citysheets-001")
    within("span.page-entries") do
      assert page.has_content?("58")
    end
  end
end
