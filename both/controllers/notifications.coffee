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
  template: 'notifications'
  data:
    title: -> 'Location Based Notifications'
    showZone: -> true
  onAfterAction: ->
    Session.set('location', true)
  waitOn: ->
    Meteor.subscribe 'notifications',
      appKey: Session.get('mobileAppKey')
      type: 'location'

Notifications.new = AppController.extend
  template: 'newNotification'
  onStop: ->
    Session.set 'location', null
  waitOn: ->
    Meteor.subscribe 'mobileApps', {}
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}
