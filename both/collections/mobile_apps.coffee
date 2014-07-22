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

createArea = (doc) ->
  areas = ['A', 'B', 'C', 'D']
  for a in areas
    area =
      name: a
      appKey: doc.appKey
    Areas.insert area

MobileApps.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt
  doc.userId    = userId unless doc.userId
  doc.zones     = [] unless doc.zones
  doc.appKey    = new Meteor.Collection.ObjectID()._str unless doc.appKey
  createDemoUser(doc)
  createArea(doc)

MobileApps.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()

MobileApps.allow
  update: ->
    true