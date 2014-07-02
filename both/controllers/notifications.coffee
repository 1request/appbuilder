Notifications.instantNotifications = AppController.extend
  template: 'notifications'
  data: 
    title: -> 'Instant Notifications'
    showZone: -> false
  waitOn: ->
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}

Notifications.lbNotifications = AppController.extend
  template: 'notifications'
  data: 
    title: -> 'Location Based Notifications'
    showZone: -> true
  waitOn: ->
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}

Notifications.new = AppController.extend
  template: 'newNotification'
  waitOn: ->
    Meteor.subscribe 'mobileApps', {},
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}
