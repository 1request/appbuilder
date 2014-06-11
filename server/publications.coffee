Meteor.publish 'mobile', (options) ->
  if options.deviceId
    member = Members.findOne(deviceId: options.deviceId)
    Mobile.find member.appId
  else
    Mobile.find({ userId: @userId })

Meteor.publish 'beacons', (options) ->
  Beacons.find(userId: @userId)

Meteor.publish 'tags', (options) ->
  if options.deviceId
    member = Members.findOne(deviceId: options.deviceId)
    app = Mobile.findOne(member.appId)
    Tags.find(_id: {$in: app.tags})
  else
    Tags.find(userId: @userId)

Meteor.publish 'currentTags', (options) ->
  self = @
  member = Members.findOne(deviceId: options.deviceId)
  app = Mobile.findOne(member.appId)
  tags = Mobile.findOne(member.appId).tags
  initializing = true

  if initializing
    for tag in Tags.find(_id: {$in: app.tags}).fetch()
      self.added 'tags', tag._id, tag

  tagHandler = Mobile.find(member.appId).observeChanges
    changed: (id, fields) ->
      unless initializing
        if fields.tags
          added = _.difference(fields.tags, tags)
          removed = _.difference(tags, fields.tags)
          if added.length
            self.added 'tags', added[0], Tags.findOne added[0]
          else
            self.removed 'tags', removed[0]
          tags = fields.tags

  initializing = false
  self.ready()
  self.onStop ->
    tagHandler.stop()

Meteor.publish 'logs', (options) ->
  if options.deviceId
    Logs.find(deviceId: options.deviceId)
  else
    app = _.pluck Mobile.find(userId: @userId).fetch(), '_id'
    members = Members.find(appId: {$in: app}).fetch()
    membersDevices = _.pluck members, 'deviceId'
    Logs.find(deviceId: {$in: membersDevices})

Meteor.publish 'members', (options) ->
  if options.deviceId
    Members.find deviceId: options.deviceId
  else if options.memberId
    Members.find options.memberId
  else
    appIds = _.pluck Mobile.find({ userId: @userId }).fetch(), '_id'
    Members.find appId: { $in: appIds }