Template.newNotification.helpers
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get 'mobileAppKey')
