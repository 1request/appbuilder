@MobileApps = new Meteor.Collection 'mobileApps'

MobileApps.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt
  doc.userId = userId unless doc.userId
  doc.appKey = new Meteor.Collection.ObjectID()._str unless doc.appKey

MobileApps.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()

MobileApps.allow
  update: ->
    true