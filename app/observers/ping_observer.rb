class PingObserver < ActiveRecord::Observer
  def after_create(ping)
    PingMailer.deliver_pingback(ping)
  end
end
