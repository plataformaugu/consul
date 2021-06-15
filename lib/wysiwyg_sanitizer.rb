class WYSIWYGSanitizer
  def allowed_tags
    %w[p ul ol li strong em u s a h2 h3 img]
  end

  def allowed_attributes
    %w[href src]
  end

  def sanitize(html)
    ActionController::Base.helpers.sanitize(html, tags: allowed_tags, attributes: allowed_attributes)
  end
end
