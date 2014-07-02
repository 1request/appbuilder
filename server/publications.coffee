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

Meteor.publish 'tags', (options) ->
  if options.deviceId
    mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
    app = MobileApps.findOne(appKey: mobileAppUser.appKey)
    Tags.find({_id: {$in: app.tags}}, {sort: {text: 1}})
  else
    Tags.find({userId: @userId}, {sort: {text: 1}})

Meteor.publish 'mobileTags', (options) ->
  self = @
  mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
  tags = MobileApps.findOne(appKey: mobileAppUser.appKey).tags

  initializing = true

  for tag in Tags.find(_id: {$in: tags}).fetch()
    self.added 'tags', tag._id, tag

  tagHandler = MobileApps.find(appKey: mobileAppUser.appKey).observe
    changed: (newDocument, oldDocument) ->
      unless initializing
        added   = _.difference newDocument.tags, oldDocument.tags
        removed = _.difference oldDocument.tags, newDocument.tags
        if added.length
          self.added 'tags', added[0], Tags.findOne added[0]
        if removed.length
          self.removed 'tags', removed[0]

  initializing = false

  self.ready()
  self.onStop ->
    tagHandler.stop()

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

Meteor.publish 'mobileAppUsers', (options) ->
  if options.deviceId and options.appKey
    MobileAppUsers.find(deviceId: options.deviceId, appKey: options.appKey)
  else
    appKeys = _.pluck MobileApps.find({ userId: @userId }).fetch(), 'appKey'
    MobileAppUsers.find({appKey: { $in: appKeys }}, {sort: {createdAt: 1}})

Meteor.publish 'notifications', (options) ->
  if options.appKey
    Notifications.find({appKey: options.appKey})

Meteor.publish 'p12s', (options) ->
  P12s.find()