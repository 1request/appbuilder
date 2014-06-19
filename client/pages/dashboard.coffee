Template.dashboard.created = ->
  Session.setDefault 'mobileAppId', MobileApps.findOne()._id
  Session.setDefault 'deviceId', MobileAppUsers.findOne(appId: Session.get 'mobileAppId').deviceId