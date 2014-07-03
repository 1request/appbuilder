@Notifications = new Meteor.Collection 'notifications'

setNotificationNote = (apn, message) ->
  if Meteor.isServer
    note = new apn.Notification()
    note.expiry = Math.floor(Date.now() / 1000) + 3600
    note.badge = 3
    note.sound = 'ping.aiff'
    note.alert = message
    note.payload =
      'messageFrom': 'Homesmartly'
    note

notifyIOS = (message, appKey, token) ->
  apn = Meteor.require 'apn'
  mobileApp = MobileApps.findOne(appKey: appKey)
  base = "#{Meteor.settings.public.storageDirectory}pems/"
  cert      = Pems.findOne(mobileApp.cert)
  key       = Pems.findOne(mobileApp.key)

  options =
    "cert": "#{base}#{cert.copies.pems.key}"
    "key":  "#{base}#{key.copies.pems.key}"
    "batchFeedback": true
    "interval": 300

  apnConnection = new apn.Connection(options)
  note = setNotificationNote(apn, message)
  device = new apn.Device(token)

  apnConnection.pushNotification(note, device)

Meteor.methods
  'createNotification': (attributes) ->
    user = Meteor.user()
    unless user
      throw new Meteor.Error(401, 'You need to login before sending notification')

    unless !!attributes.appKey
      throw new Meteor.Error(422, 'Please select an app')

    unless !!attributes.message
      throw new Meteor.Error(422, 'Please fill in message')

    unless !!attributes.type
      throw new Meteor.Error(422, 'Please fill in type')

    unless attributes.type is 'instant' or attributes.type is 'location'
      throw new Meteor.Error(422, 'Please fill in correct type')

    notification =
      appKey    : attributes.appKey
      message   : attributes.message
      url       : attributes.url
      type      : attributes.type
      createdAt : Date.now()

    if attributes.type is 'location'
      _.extend notification, { zone: attributes.zone }

    Notifications.insert notification

    if attributes.type is 'instant'
      query = {appKey: attributes.appKey, deviceType: 'iOS'}
      users = MobileAppUsers.find(query).fetch()
      for mobileAppUser in users
        notifyIOS(attributes.message, attributes.appKey, mobileAppUser.token)