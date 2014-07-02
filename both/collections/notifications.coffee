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

    notification =
      appKey    : attributes.appKey
      message   : attributes.message
      url       : attributes.url
      createdAt : Date.now()

    Notifications.insert notification
    for mobileAppUser in MobileAppUsers.find(appKey: attributes.appKey, deviceType: 'iOS').fetch()
      notifyIOS(attributes.message, attributes.appKey, mobileAppUser.token)