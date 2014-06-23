@MobileApps = new Meteor.Collection 'mobileApps'

Meteor.methods
  'createMobileApp': (appAttributes) ->
    unless !!appAttributes.name
      throw new Meteor.Error(422, 'Please fill in app name')
    app = _.pick(appAttributes, 'name')
    appId = MobileApps.insert app
    MobileApps.findOne(appId).appKey

createDemoUser = (doc) ->
  demoUser =
    appKey:   doc.appKey
    deviceId: "demo-user-#{doc.appKey}"
  MobileAppUsers.insert demoUser

MobileApps.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt
  doc.userId    = userId unless doc.userId
  doc.tags      = [] unless doc.tags
  doc.appKey    = new Meteor.Collection.ObjectID()._str unless doc.appKey
  createDemoUser(doc)

MobileApps.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()

MobileApps.allow
  update: ->
    true