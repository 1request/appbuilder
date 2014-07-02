@MobileAppUsers = new Meteor.Collection 'mobileAppUsers'

MobileAppUsers.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

MobileAppUsers.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set or= {}
  modifier.$set.updatedAt = Date.now()

Meteor.methods
  'createMobileAppUser': (appKey, deviceId) ->
    unless MobileAppUsers.findOne(deviceId: deviceId, appKey: appKey)
      MobileAppUsers.insert
        deviceId: deviceId
        appKey:   appKey