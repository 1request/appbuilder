Notifications.instantNotifications = AppController.extend
  template: 'notifications'
  data:
    title: -> 'Instant Notifications'
    showZone: -> false
  onAfterAction: ->
    Session.set('location', false)
  waitOn: ->
    Meteor.subscribe 'notifications',
      appKey: Session.get('mobileAppKey')
      type: 'instant'

Notifications.lbNotifications = AppController.extend
  template: 'lbNotifications'
  waitOn: ->
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'notifications',
      appKey: Session.get('mobileAppKey')
      type: 'location'

Notifications.editLbNotifications = AppController.extend
  template: 'newNotification'
  onAfterAction: ->
    Session.set 'location', true
    Session.set 'zone', @params.zone
    Session.set 'inApp', true
    notification = Notifications.findOne(@params.id)
    if notification
      Session.set 'notification', notification._id
      Session.set 'url', notification.url
      Session.set 'message', notification.message

  onStop: ->
    Session.set 'location', null
    Session.set 'zone', null
    Session.set 'notification', null
    Session.set 'imageId', null
    Session.set 'url', null
    Session.set 'type', null
    Session.set 'inApp', null
    Session.set 'message', null
  waitOn: ->
    Meteor.subscribe 'mobileApps', {}
    Meteor.subscribe 'zones', {_id: Session.get 'zone'}
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}

Notifications.new = AppController.extend
  template: 'newNotification'
  onAfterAction: ->
    Session.set 'location', false
  onStop: ->
    Session.set 'location', null
    Session.set 'imageId', null
    Session.set 'type', null
    Session.set "url", null
  waitOn: ->
    Meteor.subscribe 'mobileApps', {}
    Meteor.subscribe 'zones', {appKey: Session.get('mobileAppKey')}
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}
