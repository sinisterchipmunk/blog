module ArchivesHelper
  def archive_years
    @archive_years ||= Post.one_per_month.collect { |p| p.publish_date.year }.uniq
  end
  
  def archive_months(year)
    @archive_months ||= Post.one_per_month.select { |p| p.publish_date.year == year }.collect { |p| p.publish_date }
  end
  
  # Splits Post.one_per_month into a set of arrays -- one array per year. Each year contains a date representing
  # one month out of that year. If there were no posts during a given month, that month is omitted.
  def archives
    return @archives if @archives
    dates = Post.one_per_month.collect { |p| p.publish_date }
    return [] if dates.empty?
    archive = []
    archives = [ archive ]
    current_year = dates.first.year
    dates.each do |date|
      if date.year != current_year
        archive = []
        archives << archive
        current_year = date.year
      end
      archive << date
    end
    @archives = archives
  end

  # Returns a String containing the month and year of the first post, and the month and year of the last post.
  # Ex:
  #   "January 2010 through March 2011"
  def range_of_all_posts
    return @range_of_all_posts if @range_of_all_posts
    p = Post.one_per_month
    @range_of_all_posts = if p.empty?
      "(No posts)"
    else
      first = p.first.publish_date
      last = p.last.publish_date
      if first != last
        "#{first.strftime("%B %Y")} through #{last.strftime("%B %Y")}"
      else
        "#{first.strftime("%B %Y")}"
      end
    end
  end
end
