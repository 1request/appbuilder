Meteor.publish 'mobile', (options) ->
  if options.deviceId
    mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
    Mobile.find mobileAppUser.appId
  else
    Mobile.find({ userId: @userId })

Meteor.publish 'beacons', (options) ->
  if options.beaconId
    Beacons.find(options.beaconId)
  else
    Beacons.find(userId: @userId)

Meteor.publish 'tags', (options) ->
  if options.deviceId
    mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
    app = Mobile.findOne(mobileAppUser.appId)
    Tags.find(_id: {$in: app.tags})
  else
    Tags.find(userId: @userId)

Meteor.publish 'mobileTags', (options) ->
  self = @
  mobileAppUser = MobileAppUsers.findOne(deviceId: options.deviceId)
  tags = Mobile.findOne(mobileAppUser.appId).tags

  initializing = true

  for tag in Tags.find(_id: {$in: tags}).fetch()
    self.added 'tags', tag._id, tag

  tagHandler = Mobile.find(mobileAppUser.appId).observe
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

  handle = Logs.find(deviceId: options.deviceId).observeChanges
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
  deviceIds = _.pluck MobileAppUsers.find(appId: options.appId).fetch(), 'deviceId'

  handle = Logs.find(deviceId: {$in: deviceIds}).observeChanges
    added: ->
      count++
      unless initializing
        self.changed 'counts', options.appId, {count: count}

  initializing = false
  self.added 'counts', options.appId, {count: count}
  self.ready()

  self.onStop ->
    handle.stop()

Meteor.publish 'mobileAppUsers', (options) ->
  if options.deviceId
    MobileAppUsers.find deviceId: options.deviceId
  else if options.mobileAppUserId
    MobileAppUsers.find options.mobileAppUserId
  else
    appIds = _.pluck Mobile.find({ userId: @userId }).fetch(), '_id'
    MobileAppUsers.find appId: { $in: appIds }