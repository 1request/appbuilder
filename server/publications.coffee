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
    Tags.find(_id: {$in: app.tags})
  else
    Tags.find(userId: @userId)

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