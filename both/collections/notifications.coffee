@Notifications = new Meteor.Collection 'notifications'

eventHandler = (apnConnection) ->
  apnConnection.on 'connected', ->
    console.log 'connected'
  apnConnection.on 'transmitted', (notification, device) ->
    console.log 'Notification transmitted to: ' + device
  apnConnection.on 'transmissionError', (errCode, notification, device) ->
    console.error 'Notification caused error: ' + errCode + ' for device ', device.token.toString('hex'), notification
  apnConnection.on 'timeout', ->
    console.log 'connection timeout'
  apnConnection.on 'disconnected', ->
    console.log 'disconnected from APNS'
  apnConnection.on 'socketError', console.error

setNotificationNote = (apn, message) ->
  if Meteor.isServer
    note = new apn.Notification()
    note.expiry = Math.floor(Date.now() / 1000) + 3600
    note.badge = 1
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

  eventHandler(apnConnection)

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

    switch attributes.action
      when 'image'
        _.extend notification, {image: attributes.image}
      when 'floorplan'
        _.extend notification, {area: attributes.area}

    unless attributes.action in ['message', 'floorplan']
      _.extend notification, { url: attributes.url }

    id = Notifications.insert notification

    if attributes.type is 'instant'
      pushTokens = PushTokens
        .find(
          {appKey: attributes.appKey, pushType: 'ios'},
          {sort: {createdAt: -1}, fields: {deviceId: 1, pushToken: 1, createdAt: 1}}
        )
        .fetch()
      pushTokens = _(pushTokens).groupBy('deviceId')
      for k, v of pushTokens
        pushTokens[k] = v[0].pushToken
      for deviceId, pushToken of pushTokens
          notifyIOS(attributes.message, attributes.appKey, pushToken)

    if Meteor.isServer and !!attributes.imageId
      image = Images.findOne(attributes.imageId)
      image.update($set: {'metadata.notification': id})

  'updateNotification': (attributes) ->
    setOpt =
      action: attributes.action
      message: attributes.message
      trigger: attributes.trigger
      area: attributes.area
      image: attributes.image

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
