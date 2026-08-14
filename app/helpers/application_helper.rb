module ApplicationHelper
  # public/icon.* isn't asset-pipeline managed, so it has no fingerprinted
  # URL — browsers cache it (max-age=1yr) by the bare path alone. Appending
  # the file's own mtime busts that cache automatically whenever the icon
  # file changes, without needing a manually-bumped version number.
  def icon_asset_version
    @icon_asset_version ||= File.mtime(Rails.public_path.join("icon.png")).to_i
  end

  def render_technology_pills(post)
    return if post.technology_pills.empty?

    content_tag :div, class: "flex flex-wrap justify-end gap-2" do
      post.technology_pills.map do |pill|
        content_tag :span, pill[:label], class: "rounded-full px-3 py-1 text-xs font-semibold #{pill[:classes]}"
      end.join.html_safe
    end
  end
end
