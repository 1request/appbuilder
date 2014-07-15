setDropZone = ->
  dropzoneOptions =
    addRemoveLinks: true
    acceptedFiles: 'image/*'
    maxFiles: 1

  dropZone = new Dropzone('#dropzone', dropzoneOptions)

  dropZone.on 'addedfile', (file) ->
    Images.insert file, (error, fileObj) ->
      Session.set('imageId', fileObj._id)

  dropZone.on 'success', (file) ->
    throwAlert 'Image uploaded'

createNotification = (notification) ->
  Meteor.call 'createNotification', notification, (error, result) ->
    if error
      throwAlert(error.reason)
    else
      if notification.type is 'instant'
        Router.go 'instantNotifications'
        throwAlert("successfully send notification")
      else if Session.get 'walkthrough'
        Router.go 'editMobileApp'
        Session.set 'walkthrough', null
        throwAlert("Notification updated successfully! Next, you can edit app detail and update notification certificate here")
      else
        Router.go 'lbNotifications'
        throwAlert("Notification updated successfully!")

updateNotification = (notification) ->
  Meteor.call 'updateNotification', notification, (error, result) ->
    if error
      throwAlert(error.reason)
    else
      if notification.type is 'instant'
        Router.go 'instantNotifications'
        throwAlert("successfully send notification")
      else
        Router.go 'lbNotifications'
        throwAlert("Notification updated successfully")

Template.imageDropZone.rendered = ->
  setDropZone()

Template.newNotification.helpers
  zone: ->
    Zones.findOne(_id: Session.get 'zone')
  isLbn: ->
    Session.get('location')
  showUrl: ->
    Session.get('type') is 'url' or Session.get('type') is 'video'
  url: ->
    Session.get('url')
  image: ->
    Session.get('type') is 'image'
  floorplan: ->
    Session.get('type') is 'floorplan'
  notification: ->
    notification = Notifications.findOne(Session.get 'notification')
  actionSelected: (action) ->
    notification = Notifications.findOne(Session.get 'notification')
    if notification
      action == notification.action
  triggerSelected: (trigger) ->
    notification = Notifications.findOne(Session.get 'notification')
    if !!notification and !!notification.trigger
      trigger is notification.trigger
    else
      ''
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get('mobileAppKey'))
  message: ->
    Session.get('message')
  inApp: ->
    Session.get('inApp')


Template.newNotification.rendered = ->
  Session.setDefault('location', false)
  Session.setDefault('showUrl', false)
  $('.preview-button').tooltip()
  notification = Notifications.findOne(zone: Session.get 'zone')
  if notification.area
    $("##{notification.area}").parent().addClass('active')

  @corsDep = Deps.autorun ->
    url = Session.get('url')
    Meteor.call 'testCORS', url, (error, result) ->
      if Session.get('showUrl')
        Session.set('url', result)

  @subscribeImagesDep = Deps.autorun ->
    Meteor.subscribe 'images', id: Session.get('imageId')
    if Images.findOne() and Session.get('type') is 'image'
      Session.set('url', Images.findOne().url())

Template.newNotification.events
  'change #type': (e) ->
    if e.target.value is 'location'
      Session.set "location", true
    else
      Session.set "location", false

  'change #action': (e) ->
    Session.set('type', e.target.value)

  'keyup input[name="message"]': (e) ->
    Session.set('message', e.target.value)

  'change input[name="url"]': (e) ->
    Session.set('url', e.target.value)

  'submit form': (e) ->
    e.preventDefault()
    imageId = Session.get('imageId')
    message = $('input[name="message"]').val()
    type = if Session.get 'location' then 'location' else 'instant'
    action = $('select[name="action"]').val()
    locationAttributes =
      zone: Session.get 'zone'
      trigger: $('select[name="trigger"]').val()
      area: $('input[name="area"]:checked').val()
    switch action
      when 'image'
        url = Session.get('url')
      when 'message'
        url = null
      else
        url = $('input[name="url"]').val()

    unless !!message
      throwAlert('Please provide message')
    else if action is 'url' and !url
      throwAlert('Please provide url')
    else
      notification = Notifications.findOne(Session.get 'notification')
      if notification
        # appKey, type, zone unchange
        notification.action = action
        notification.url = url
        notification.message = message
        notification.trigger = locationAttributes.trigger
        if locationAttributes.area then notification.area = locationAttributes.area
        updateNotification(notification)
      else
        notification =
          appKey: Session.get('mobileAppKey')
          message: message
          type: type
          action: action

        unless action is 'message' then _.extend notification, { url: url }
        if type is 'location' then _.extend notification, locationAttributes
        if !!imageId then _.extend notification, { imageId: imageId }
        createNotification(notification)

  'click .preview-button': (e) ->
    Session.set('inApp', !Session.get('inApp'))
    if Session.get 'inApp'
      $(e.target).removeClass('fa-caret-square-o-right')
      $(e.target).addClass('fa-caret-square-o-left')
    else
      $(e.target).removeClass('fa-caret-square-o-left')
      $(e.target).addClass('fa-caret-square-o-right')

Template.newNotification.destroyed = ->
  if @corsDep
    @corsDep.stop()
  if @subscribeImagesDep
    @subscribeImagesDep.stop()