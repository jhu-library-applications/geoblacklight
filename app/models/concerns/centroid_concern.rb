# frozen_string_literal: true

module CentroidConcern
  extend Geoblacklight::SolrDocument

  # Return String of document centroid value
  def centroid
    fetch(Settings.FIELDS.CENTROID, '')
  end
end
