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
end
