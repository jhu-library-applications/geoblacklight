module ApplicationHelper

  # Always return an array of geom type values
  def geom_types(types)
    types = [*types]
  end

  def csrf_meta_tags
    super
  rescue ArgumentError
    request.reset_session
    super
  end
end
