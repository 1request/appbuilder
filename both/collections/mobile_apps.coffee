@MobileApps = new Meteor.Collection 'mobileApps'

MobileApps.before.insert (userId, doc) ->
  doc.userId = userId unless doc.userId
  doc.appKey = new Meteor.Collection.ObjectID()._str unless doc.appKey

MobileApps.allow
  update: ->
    true