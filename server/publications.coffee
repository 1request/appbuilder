Meteor.publish 'mobileApps', (options) ->
  if options.appKey
    MobileApps.find(appKey: options.appKey)
  else
    MobileApps.find({ userId: @userId }, {sort: {createdAt: 1}})

Meteor.publish 'beacons', (options) ->
  if options.beaconId
    Beacons.find(options.beaconId)
  else
    Beacons.find({userId: @userId}, {sort: {createdAt: 1}})

Meteor.publish 'zones', (options) ->
  if options.deviceId
    mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
    app = MobileApps.findOne(appKey: mobileAppUser.appKey)
    Zones.find({_id: {$in: app.zones}}, {sort: {text: 1}})
  else if options.appKey
    app = MobileApps.findOne(appKey: options.appKey)
    Zones.find({_id: {$in: app.zones}}, {sort: {text: 1}})
  else
    Zones.find({userId: @userId}, {sort: {text: 1}})

Meteor.publish 'mobileZones', (options) ->
  self = @
  mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
  zones = MobileApps.findOne(appKey: mobileAppUser.appKey).zones

  initializing = true

  for zone in Zones.find(_id: {$in: zones}).fetch()
    self.added 'zones', zone._id, zone

  zoneHandler = MobileApps.find(appKey: mobileAppUser.appKey).observe
    changed: (newDocument, oldDocument) ->
      unless initializing
        added   = _.difference newDocument.zones, oldDocument.zones
        removed = _.difference oldDocument.zones, newDocument.zones
        if added.length
          self.added 'zones', added[0], Zones.findOne added[0]
        if removed.length
          self.removed 'zones', removed[0]

  initializing = false

  self.ready()
  self.onStop ->
    zoneHandler.stop()

Meteor.publish 'counts-by-mobileAppUser', (options) ->
  self = @
  count = 0
  initializing = true

  handle = Logs.find(deviceId: options.deviceId, appKey: options.appKey).observeChanges
    added: ->
      count++
      unless initializing
        self.changed 'counts', options.deviceId, {count: count}

  initializing = false
  self.added 'counts', options.deviceId, {count: count}
  self.ready()

  self.onStop ->
    handle.stop()

Meteor.publish 'hasBeacons', (options) ->
  self = @
  initializing = true
  userId = @userId

  if userId
    handle = Beacons.find(userId: userId).observeChanges
      added: ->
        unless initializing
          self.changed 'hasBeacons', userId, {hasBeacons: !!Beacons.find(userId: userId).count()}
      removed: ->
        unless initializing
          self.changed 'hasBeacons', userId, {hasBeacons: !!Beacons.find(userId: userId).count()}

    initializing = false

    self.added 'hasBeacons', userId, {hasBeacons: !!Beacons.find(userId: userId).count()}

    self.onStop ->
      handle.stop()

  self.ready()

Meteor.publish 'counts-by-app', (options) ->
  self = @
  count = 0
  initializing = true

  handle = Logs.find(appKey: options.appKey).observeChanges
    added: ->
      count++
      unless initializing
        self.changed 'counts', options.appKey, {count: count}

  initializing = false
  self.added 'counts', options.appKey, {count: count}
  self.ready()

  self.onStop ->
    handle.stop()

Meteor.publish 'images', (options) ->
  if options.id
    Images.find(options.id, owner: @userId)
  else
    Images.find(owner: @userId)

Meteor.publish 'mobileAppUsers', (options) ->
  if options.deviceId and options.appKey
    MobileAppUsers.find(deviceId: options.deviceId, appKey: options.appKey)
  else
    appKeys = _.pluck MobileApps.find({ userId: @userId }).fetch(), 'appKey'
    MobileAppUsers.find({appKey: { $in: appKeys }}, {sort: {createdAt: 1}})

Meteor.publish 'notifications', (options) ->
  if options.type
    Notifications.find({appKey: options.appKey, type: options.type})
  else
    Notifications.find({appKey: options.appKey})

Meteor.publish 'p12s', (options) ->
  P12s.find()

Meteor.publish 'areas', (options) ->
  if options.id
    Areas.find(options.id)
  else
    Areas.find(appKey: options.appKey)