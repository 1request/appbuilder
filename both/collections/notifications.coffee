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
  apn       = Meteor.require 'apn'
  mobileApp = MobileApps.findOne(appKey: appKey)
  production = if mobileApp.status is 'production' then true else false
  base      = "#{Meteor.settings.public.storageDirectory}pems/"
  cert      = Pems.findOne(mobileApp.cert)
  key       = Pems.findOne(mobileApp.key)

  options =
    "cert": "#{base}#{cert.copies.pems.key}"
    "key":  "#{base}#{key.copies.pems.key}"
    "batchFeedback": true
    "production": production
    "interval": 300

  apnConnection = new apn.Connection(options)
  note = setNotificationNote(apn, message)
  device = new apn.Device(token)

  apnConnection.pushNotification(note, device)

Meteor.methods
  'destroyNotification': (notificationId) ->
    user = Meteor.user()
    unless user
      throw new Meteor.Error(401, 'You need to login to delete existing beacons')

    Notifications.remove notificationId

  'createNotification': (attributes) ->
    user = Meteor.user()
    unless user
      throw new Meteor.Error(401, 'You need to login before sending notification')

    unless !!attributes.appKey
      throw new Meteor.Error(422, 'Please select an app')

    unless !!attributes.message
      throw new Meteor.Error(422, 'Please fill in message')

    unless !!attributes.action
      throw new Meteor.Error(422, 'Please fill in action')

    unless attributes.action in ['message', 'url', 'image', 'video', 'floorplan']
      throw new Meteor.Error(422, 'Please fill in correct action')

    unless !!attributes.type
      throw new Meteor.Error(422, 'Please fill in type')

    unless attributes.type is 'instant' or attributes.type is 'location'
      throw new Meteor.Error(422, 'Please fill in correct type')

    notification =
      appKey    : attributes.appKey
      message   : attributes.message
      type      : attributes.type
      action    : attributes.action
      createdAt : Date.now()

    if attributes.type is 'location'
      _.extend notification,
        zone: attributes.zone
        trigger: attributes.trigger
        area: attributes.area

    unless attributes.action is 'message'
      _.extend notification, { url: attributes.url }

    id = Notifications.insert notification

    if attributes.type is 'instant'
      pushTokens = PushTokens
        .find(appKey: attributes.appKey, pushType: 'ios')
        .fetch()
      if pushTokens
        for token in pushTokens
          notifyIOS(attributes.message, attributes.appKey, token.pushToken)

    if Meteor.isServer and !!attributes.imageId
      image = Images.findOne(attributes.imageId)
      image.update($set: {'metadata.notification': id})

  'updateNotification': (attributes) ->
    setOpt =
      action: attributes.action
      message: attributes.message
      trigger: attributes.trigger
      area: attributes.area

    if attributes.action is 'message'
      unsetOpt =
        url: 1
    else
      setOpt.url = attributes.url

    if unsetOpt
      Notifications.update attributes._id,
        $set: setOpt
        $unset: unsetOpt
    else
      Notifications.update attributes._id,
        $set: setOpt
