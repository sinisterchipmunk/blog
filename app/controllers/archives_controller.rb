class ArchivesController < ApplicationController
  def index
  end

  def month_and_year
    @date = DateTime.strptime("#{params[:year]} #{params[:month]}", "%Y %m")
    @posts = Post.find(:all,
                       :conditions => { :publish_date => @date.beginning_of_month..@date.end_of_month },
                       :order => 'publish_date DESC')
  end
end
