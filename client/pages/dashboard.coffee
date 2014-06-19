Template.dashboard.created = ->
  Session.setDefault 'mobileAppKey', MobileApps.findOne().appKey
  Session.setDefault 'deviceId', MobileAppUsers.findOne(appKey: Session.get 'mobileAppKey').deviceId