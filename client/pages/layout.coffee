Template.layout.helpers
  'isMobile': ->
    paths = ['mobileApp', 'monthlyLog', 'notification', 'cors']
    current = Router.current()
    if current then current.route.name in paths