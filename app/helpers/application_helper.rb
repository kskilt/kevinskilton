module ApplicationHelper
  def render_technology_pills(post)
    return if post.technology_pills.empty?

    content_tag :div, class: "flex flex-wrap justify-end gap-2" do
      post.technology_pills.map do |pill|
        content_tag :span, pill[:label], class: "rounded-full px-3 py-1 text-xs font-semibold #{pill[:classes]}"
      end.join.html_safe
    end
  end
end
