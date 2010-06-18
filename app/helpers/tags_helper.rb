## WHY?! Without this I get "...removed from module tree but is still active!"
require_dependency "tag"

module TagsHelper
  def tag_bubble(max_font_size = "0.5in", min_font_size = 0.1)
    unit = "in"
    if max_font_size.kind_of?(String) && max_font_size =~ /^([0-9\.]+)([a-zA-Z]+)$/
      unit = $~[2]
      max_font_size = $~[1]
    end
    tags = Tag.find(:all, :order => 'name ASC')
    tags.collect { |t| tag_bubble_item(tags, t, max_font_size, min_font_size, unit) }.join(" ")
  end

  def tag_bubble_item(all, which, max_font_size = '0.5', min_font_size = 0.1, font_unit = 'in')
    weights = all.collect { |t| t.posts.count }
    weight = weights[all.index(which)]
    total = weights.inject { |a, b| a + b }
    return '' if total == 0 || weight == 0

    size = ((max_font_size.to_f - min_font_size.to_f) * weight.to_f / total.to_f) + min_font_size.to_f
    "<span style='font-size:#{size}#{font_unit};'>#{link_to which.name, which}</span>"
  end
end
