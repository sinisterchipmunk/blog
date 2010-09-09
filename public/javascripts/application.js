/*
   the effects used here can cause the sidebar to be positioned with +left+
   instead of +right+, which causes issues if a user resizes window afterward.
   So all we do here is recalculate the proper value for +left+ and let
   the browser do its thing.
       
   I tried to force usage of +right+ and it worked fine under Firefox, but
   it croaked under Chrome. I decided it was better to go this route in the end,
   even though it makes the stylesheets a little more confusing (since they assign
   +right+ to begin with) and adds a small amount of JS overhead. Using +left+
   at the outset isn't an option because we don't initially know the bounds of
   the +content+ div.
 */
function recalculate_sidebar_bounds()
{
  $('sidebar').style.left = ($('content').getDimensions().width+5+$('content').cumulativeOffset().left)+"px";
  $('sidebar').style.right = 'auto';
}

/*
  When called, this function will cause the sidebar to collapse or expand, thus
  moving it out of the way to reduce clutter and recalling it when needed.
 */
function toggleSidebar()
{
  if (toggleSidebar.collapsed)
  {
    new Effect.Grow('sidebar', { direction: 'top-right', afterFinish: recalculate_sidebar_bounds });
    new Effect.Morph('content', { style: 'margin-right:205px;' });
    new Effect.Morph('collapse-sidebar', { style: 'right:238px;' });
    toggleSidebar.collapsed = false;
  }
  else
  {
    recalculate_sidebar_bounds();
    new Effect.DropOut('sidebar');
    new Effect.Morph('content', { style: 'margin-right:5px;' });
    new Effect.Morph('collapse-sidebar', { style: 'right:38px;' });
    toggleSidebar.collapsed = true;
  }
}

/*
  This function calculates the height and top position of the sidebar,
  compares that to the size and scroll offsets of the window, and
  repositions the sidebar accordingly. This is because, since the sidebar
  is positioned using position:fixed, it is impossible for the user to
  scroll down within the sidebar if it's too long for the window. Rather
  than add a nested div with overflow:auto, which is ugly, I decided to
  go this route. This way the user can scroll down but won't ever scroll
  past the end of the sidebar. This reduces the amount of wasted space and
  prevents the user from having to scroll back up to use the sidebar.
 */
var window_scrolled = function(evt)
{
  // return early if the sidebar is hidden so we don't conflict with scriptaculous
  if ($('sidebar').style.display == "none") return;
  
  // This is nitpicky, but there's about a 15px offset at the top of the page.
  // I like the offset for #content but hate it for the #sidebar because it seems
  // like too much once the user scrolls down. So we'll calculate an offset, which
  // becomes smaller as the user scrolls down, and offset the sidebar by that amount.
  // (Hey, it's my site -- I'll do what I want.) :)
  var scroll = document.viewport.getScrollOffsets().top;
  var offset = $("outer").cumulativeOffset().top;
  offset -= scroll;
  if (offset < 0) offset = 0;
  
  var window_height = (document.viewport.getDimensions().height);
  var sidebar_height = ($('sidebar').getHeight());
  var sidebar_top = $('sidebar').cumulativeOffset().top - $("outer").cumulativeOffset().top;
  window_scrolled.origin = window_scrolled.origin || sidebar_top;
  var origin = window_scrolled.origin;
  
  sidebar_top = origin;
  if (window_height < sidebar_height)
  {
    sidebar_top -= scroll;
    
    if (window_height - sidebar_top > sidebar_height)
      sidebar_top = -(sidebar_height - window_height);
  }
  sidebar_top += offset;
  
  $('sidebar').style.top = sidebar_top+"px";
  $('sidebar-scroll-mirror').style.top = sidebar_top+"px";
  $('sidebar-scroll-mirror').style.height = sidebar_height+"px";
  // we need a buffer of some sort to prevent jittering in FF. Pretty sure this has to do with offset
  // but adding offset doesn't solve the problem.
  $('border-center').style.minHeight = (sidebar_top+sidebar_height+30)+"px";
  recalculate_sidebar_bounds();
}

Event.observe(window, 'scroll', window_scrolled);
Event.observe(window, 'resize', window_scrolled);
Event.observe(window, 'load',   window_scrolled); // mostly just to populate $("sidebar-scroll-mirror")

