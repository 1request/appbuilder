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
  tags = Mobile.findOne(member.appId).tags

  initializing = true

  for tag in Tags.find(_id: {$in: tags}).fetch()
    console.log 'in tag loop'
    self.added 'tags', tag._id, tag

  tagHandler = Mobile.find(member.appId).observe
    changed: (newDocument, oldDocument) ->
      unless initializing
        added   = _.difference newDocument.tags, oldDocument.tags
        removed = _.difference oldDocument.tags, newDocument.tags
        if added.length
          console.log 'add ', Tags.findOne(added[0]).text
          self.added 'tags', added[0], Tags.findOne added[0]
        else
          console.log 'remove ', Tags.findOne(removed[0]).text
          console.log 'id to be removed', removed[0]
          self.removed 'tags', removed[0]

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