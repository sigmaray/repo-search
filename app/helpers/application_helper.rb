module ApplicationHelper
  def escape_html_template(template)
    template.gsub('"', "'").html_safe
  end
end
