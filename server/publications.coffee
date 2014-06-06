Meteor.publish 'mobile', (options) ->
  if options.appId
    Mobile.find options.appId
  else
    Mobile.find({ userId: @userId })

Meteor.publish 'beacons', (options) ->
  if options.appId
    Beacons.find(appId: options.appId)

Meteor.publish 'tags', (options) ->
  if options.appId
    Tags.find(appId: options.appId)

Meteor.publish 'logs', (options) ->
  if options.memberId
    member = Members.findOne(options.memberId)
    Logs.find(deviceId: member.deviceId)
  else
    app = _.pluck Mobile.find(userId: @userId).fetch(), '_id'
    members = Members.find(appId: {$in: app}).fetch()
    membersDevices = _.pluck members, 'deviceId'
    Logs.find(deviceId: {$in: membersDevices})

Meteor.publish 'members', (options) ->
  if options.appId
    Members.find appId: options.appId
  else if options.memberId
    Members.find options.memberId
  else
    appIds = _.pluck Mobile.find({ userId: @userId }).fetch(), '_id'
    Members.find appId: { $in: appIds }