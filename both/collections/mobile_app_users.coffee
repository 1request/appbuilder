@MobileAppUsers = new Meteor.Collection 'mobileAppUsers'

MobileAppUsers.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

MobileAppUsers.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()