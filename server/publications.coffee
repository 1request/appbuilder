Meteor.publish 'mobile', (options) ->
  if options.appId
    Mobile.find options.appId
  else
    Mobile.find({ userId: @userId })

Meteor.publish 'beacons', ->
  Beacons.find()

Meteor.publish 'tags', (options) ->
  app = Mobile.findOne { userId: @userId }
  Tags.find appId: options.appId

Meteor.publish 'logs', ->
  app = _.pluck Mobile.find(userId: @userId).fetch(), '_id'
  members = Members.find(appId: {$in: app}).fetch()
  membersDevices = _.pluck members, 'deviceId'
  Logs.find(deviceId: {$in: membersDevices})

Meteor.publish 'members', (options) ->
  if options.appId
    Members.find appId: options.appId
  else
    appIds = _.pluck Mobile.find({ userId: @userId }).fetch(), '_id'
    Members.find appId: { $in: appIds }