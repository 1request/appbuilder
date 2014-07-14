Template.layout.helpers
  'isMobile': ->
    mobileAppPaths = ['mobileApp', 'monthlyLog', 'notification']
    current = Router.current()
    if current
      true if current.route.name in mobileAppPaths