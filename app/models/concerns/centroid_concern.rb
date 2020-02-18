# frozen_string_literal: true

module CentroidConcern
  extend Geoblacklight::SolrDocument

  # Return String of document centroid value
  def centroid
    fetch(:b1g_centroid_ss, '')
  end
end
