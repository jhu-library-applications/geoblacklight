require "application_system_test_case"

class SearchResultsPageTest < ApplicationSystemTestCase
  def setup
  end

  def test_basic_dom
    visit '/?q=water'
    assert page.has_selector?("header#topnav")          # JHU Branding
    assert page.has_selector?("nav#header-navbar")      # Static Pages
    assert page.has_selector?("nav#search-navbar")      # Search Form
    assert page.has_selector?("div#main-container")     # Main
    within("div#main-container") do
      assert page.has_selector?("div#appliedParams")    # Constraints
      assert page.has_selector?("section#content")      # Results
      assert page.has_selector?("div.page-links")       # Pagination
      assert page.has_selector?("div.search-widgets")   # Result Options
      assert page.has_selector?("div#sort-dropdown")    # Sorting
      assert page.has_selector?("div#per_page-dropdown")# Per Page
      assert page.has_selector?("section#sidebar")      # Facets
    end

    assert page.has_selector?("footer")                 # Footer
  end

  def test_search
    visit '/?q=water'
    assert page.has_content?("Search Results")
    assert page.has_content?("You searched for")
    assert page.has_link?("Clear search")
  end

  def test_map_clustering
    skip("MarkerCluster not yet implemented")
    # Map centered on USA. Records have cluster centroid values.
    visit '/?utf8=✓&view=mapview&q=&search_field=all_fields&bbox=-177.129822%20-36.81918%20-28.067322%2074.70319'
    assert page.has_selector?("div.marker-cluster")
  end

  def test_empty_search
    visit '/?utf8=✓&q=&search_field=all_fields'
    assert page.assert_selector('article.document', :count => 10)
  end

  def test_facets
    visit '/?utf8=✓&q=&search_field=all_fields'
    assert page.has_selector?("#facets")
    within("#facets") do
      assert page.has_content?("Place")
      assert page.has_content?("Genre")
      assert page.has_content?("Year")
      assert page.has_content?("Subject")
      assert page.has_content?("Time Period")
      assert page.has_content?("Publisher")
      assert page.has_content?("Creator")
      assert page.has_content?("Institution")
      assert page.has_content?("Type")
    end
  end

  def test_sort_options
    visit '/?q=water'
    click_button("Sort by Relevance")
    within("#sort-dropdown") do
      assert page.has_content?("Relevance")
      assert page.has_content?("Year (Newest first)")
      assert page.has_content?("Year (Oldest first)")
      assert page.has_content?("Title (A-Z)")
      assert page.has_content?("Title (Z-A)")
    end
  end

  def test_map_clustering
    # Map centered on USA. B1G records have cluster centroid values.
    visit '/?utf8=✓&view=mapview&q=&search_field=all_fields&bbox=-177.129822%20-36.81918%20-28.067322%2074.70319'
    assert page.has_selector?("div.marker-cluster")
  end
end
