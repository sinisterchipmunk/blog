class PingObserver < ActiveRecord::Observer
  def after_create(ping)
    PingbackMailer.deliver_pingback(ping)
  end
end
