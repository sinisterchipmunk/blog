(function (jQuery) {
  jQuery.fn.boastful = function(options){
    options = options || {}
    var output = jQuery(this)
    var defaults = {
                      location: location.href,
                      empty_message: 'No one\'s mentioned this page on Twitter yet. '+
                                       '<a href="http://twitter.com?status='+(options.empty_message || location.href)+'">'
                                       +'You could be the first</a>.',
                      limit: 50
                   }
    var settings = jQuery.extend(defaults, options)

    function format_tweetback(tweetback) {
      formatted = ''
      formatted += '<div class="boastful">'
      formatted += '<a href="'+tweetback.permalink_url+'">'
      formatted += '<img src="'+tweetback.author.photo_url+'" />'
      formatted += '</a>'
      formatted += '<div class="boastful_pointer"></div>'
      formatted += '<div class="boastful_tweet" style="display: none">'
      formatted += '<div class="boastful_handle">@'+tweetback.author.url.split('/').pop()+'</div>'
      formatted += '<div class="boastful_content">'+tweetback.content+'</div>'
      formatted += '</div>'
      formatted += '</div>'
      return formatted
    }

    var parse_request = function(data){
      if(data.response.list.length > 0) {
        jQuery.each(data.response.list, function(i,tweetback){
          output.append(format_tweetback(tweetback))
          jQuery('.boastful').mouseover(function(){ jQuery(this).children('.boastful_tweet, .boastful_pointer').show() })
          jQuery('.boastful').mousemove(function(kmouse){
            jQuery(this).children('.boastful_tweet').css({
              left:jQuery(this).position().left-105,
              top:jQuery(this).position().top+25
            })
            jQuery(this).children('.boastful_pointer').css({
              left:jQuery(this).position().left+18,
              top:jQuery(this).position().top+15
            })
          })
          jQuery('.boastful').mouseout(function(){ jQuery(this).children('.boastful_tweet, .boastful_pointer').hide() })
        });
      } else {
        output.append(defaults.empty_message)
      }
    }

    jQuery.ajax({
      url:'http://otter.topsy.com/trackbacks.js',
      data:
        {
          url: defaults.location,
          perpage: defaults.limit
        },
      success:parse_request,
      dataType:'jsonp'}
    );

    return this
  }
})(jQuery);
