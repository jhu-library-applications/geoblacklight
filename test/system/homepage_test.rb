require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
  def setup
    visit("/")
  end

  def test_basic_dom
    assert page.has_selector?("header#topnav")          # JHU Branding
    assert page.has_selector?("nav#header-navbar")      # Static Pages
    assert page.has_selector?("div#main-container")     # Main
    assert page.has_selector?("[data-analytics-id]")    # Google Analytics
    assert page.has_selector?("form.search-query-form") # Search Form
    assert page.has_selector?("div#map")                # Map
    assert page.has_selector?("div.leaflet-pane")       # Leaflet
    assert page.has_selector?("footer")                 # Footer
  end

  def test_homepage_copy
    within("header#topnav") do
      # Logo Link
      assert page.has_link?(href: "https://www.library.jhu.edu/")
      assert page.has_content?("GeoPortal")
    end

    within("nav#header-navbar") do
      assert page.has_link?("About")
      assert page.has_link?("Contact")
      assert page.has_link?("Help")
    end

    within("div#main-container") do
      assert page.has_content?("Discover and download GIS data and maps")
      assert page.has_link?("Advanced")
      assert page.has_content?("Explore")
      assert page.has_content?("Hackerman Maps")
      assert page.has_content?("Maryland LiDAR")
      assert page.has_content?("Fish and Game")
      assert page.has_content?("Watersheds")
      assert page.has_content?("Search an area like Maryland or zoom out to explore")
    end

    within("footer") do
      assert page.has_content?("Johns Hopkins University Data Services")
      assert page.has_link?(href: "https://dataservices.library.jhu.edu/")

      # Contact Us
      assert page.has_link?(href: "mailto:dataservices@jhu.edu")

      # Mailing Lists
      assert page.has_content?("Mailing List")
      assert page.has_link?(href: "mailto:dataservices-request@lists.johnshopkins.edu?subject=subscribe%20dataservices")

      # Copyright
      assert page.has_content?("© #{Time.now.year} Johns Hopkins University")

      # Legal Menu
      assert page.has_link?("Privacy")
      assert page.has_link?("Confidentiality")
      assert page.has_link?("Disclaimer")
      assert page.has_link?("Policies")
    end
  end

  def test_homepage_search
    within("form.search-query-form") do
      fill_in("q", with: 'water')
      click_button 'Search'
    end

    assert page.has_content?("Search Results")
  end
end
