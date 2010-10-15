#BotAway.show_honeypots = true
#BotAway.dump_params = true
BotAway.accepts_unfiltered_params "role_ids", "category[name]", "category_ids", "image[file]"
BotAway.accepts_unfiltered_params "tag_ids",  "tag[name]",      "publish_date"
BotAway.disabled_for :controller => "sparkly_sessions"
BotAway.disabled_for :mode => 'cucumber'
