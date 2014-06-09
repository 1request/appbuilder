manageSidebar = ($html, $sidebar, $sidebar_submenu, $sidebar_toggle) ->
  destroySideScroll = ->
    $sidebar.mCustomScrollbar "destroy"
  createSideScroll = ->
    destroySideScroll()
    unless /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      $sidebar.mCustomScrollbar
        scrollButtons:
          enable: false
        autoHideScrollbar: true
        scrollInertia: 150
        theme: "light-thin"
        advanced:
          updateOnContentResize: true

  $(window).bind "enterBreakpoint1200", ->
    $html.removeClass().addClass "sidebar-large"
    $(".sidebar-nav li.current").addClass "active"
    $(".sidebar-nav li.current .submenu").addClass("in").height "auto"
    $sidebar_toggle.attr "id", "menu-medium"
    $sidebar.removeClass "collapse"
    sidebarHeight()
    createSideScroll()

  $(window).bind "enterBreakpoint768", ->
    $html.removeClass("sidebar-hidden").removeClass("sidebar-large").removeClass("sidebar-thin").addClass "sidebar-medium"
    $(".sidebar-nav li.current").removeClass "active"
    $(".sidebar-nav li.current .submenu").removeClass "in"
    $sidebar_toggle.attr "id", "menu-thin"
    sidebarHeight()
    $sidebar.removeClass "collapse"
    $("#menu-right").trigger "close"
    destroySideScroll()

  $(window).bind "enterBreakpoint480", ->
    $html.removeClass("sidebar-medium").removeClass("sidebar-large").removeClass("sidebar-hidden").addClass "sidebar-thin"
    $(".sidebar-nav li.current").removeClass "active"
    $(".sidebar-nav li.current .submenu").removeClass "in"
    $sidebar.removeClass "collapse"
    sidebarHeight()
    destroySideScroll()

  $(window).bind "enterBreakpoint320", ->
    $html.removeClass("sidebar-medium").removeClass("sidebar-large").removeClass("sidebar-thin").addClass "sidebar-hidden"
    sidebarHeight()
    destroySideScroll()

  $(document).on "click", "#menu-large", ->
    $html.removeClass("sidebar-medium").removeClass("sidebar-hidden").removeClass("sidebar-thin").addClass "sidebar-large"
    $sidebar_toggle.attr "id", "menu-medium"
    $(".sidebar-nav li.current").addClass "active"
    $(".sidebar-nav li.current .submenu").addClass("in").height "auto"
    sidebarHeight()
    createSideScroll()

  $(document).on "click", "#menu-medium", ->
    $html.removeClass("sidebar-hidden").removeClass("sidebar-large").removeClass("sidebar-thin").addClass "sidebar-medium"
    $sidebar_toggle.attr "id", "menu-thin"
    $(".sidebar-nav li.current").removeClass "active"
    $(".sidebar-nav li.current .submenu").removeClass "in"
    sidebarHeight()
    destroySideScroll()

  $(document).on "click", "#menu-thin", ->
    $html.removeClass("sidebar-medium").removeClass("sidebar-large").removeClass("sidebar-thin").addClass "sidebar-thin"
    $sidebar_toggle.attr "id", "menu-large"
    $(".sidebar-nav li.current").removeClass "active"
    $(".sidebar-nav li.current .submenu").removeClass "in"
    sidebarHeight()
    $sidebar_toggle.attr "id", "menu-medium"  if $("body").hasClass("breakpoint-768")
    destroySideScroll()

toggleSidebarMenu = ->
  $this = $(".sidebar-nav")
  $this.find("li.active").has("ul").children("ul").addClass "collapse in"
  $this.find("li").not(".active").has("ul").children("ul").addClass "collapse"
  $this.find("li").has("ul").children("a").on "click", (e) ->
    e.preventDefault()
    $(this).parent("li").toggleClass("active").children("ul").collapse "toggle"
    $(this).parent("li").siblings().removeClass("active").children("ul.in").collapse "hide"

sidebarHeight = ($html, $sidebar) ->
  sidebar_height = undefined
  mainMenuHeight = parseInt($("#main-menu").height())
  windowHeight = parseInt($(window).height())
  mainContentHeight = parseInt($("#main-content").height())
  sidebar_height = windowHeight  if windowHeight > mainMenuHeight and windowHeight > mainContentHeight
  sidebar_height = mainMenuHeight  if mainMenuHeight > windowHeight and mainMenuHeight > mainContentHeight
  sidebar_height = mainContentHeight  if mainContentHeight > mainMenuHeight and mainContentHeight > windowHeight
  if $html.hasClass("sidebar-large") or $html.hasClass("sidebar-hidden")
    $sidebar.height ""
  else
    $sidebar.height sidebar_height

Template.sidebar.rendered = ->
  $(window).setBreakPoints
    distinct: true,
    breakpoints: [320, 480, 768, 1200]

  NProgress.configure
    showSpinner: false
  .start()
  Meteor.setTimeout ->
    NProgress.done()
    $('.fade').removeClass('out')
  , 1000

  $html = $("html")
  $sidebar = $("#sidebar")
  $sidebar_toggle = $(".sidebar-toggle")
  $sidebar_submenu = $(".submenu")
  manageSidebar($html, $sidebar, $sidebar_submenu, $sidebar_toggle)
  toggleSidebarMenu()
  sidebarHeight($html, $sidebar)

  $(window).bind "resize", (e) ->
    window.resizeEvt
    $(window).resize ->
      clearTimeout window.resizeEvt
      window.resizeEvt = setTimeout(->
        sidebarHeight()
        liveTile()
        customScroll()
        handleSlider()
      , 250)
