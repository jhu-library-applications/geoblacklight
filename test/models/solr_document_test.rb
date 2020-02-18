require 'test_helper'

class SolrDocumentTest < ActiveSupport::TestCase
  def setup
    cat = Blacklight::SearchService.new(
      config: CatalogController.blacklight_config
    )
    _resp, @document = cat.fetch("99-0001-test")
  end

  test 'supports centroid' do
    assert @document.respond_to? :centroid
  end
end
