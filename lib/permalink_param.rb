module PermalinkParam
  def to_param
    permalink || id.to_s
  end
end
