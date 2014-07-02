Notifications.instantNotifications = AppController.extend
  template: 'notifications'
  waitOn: ->
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}

Notifications.new = AppController.extend
  template: 'newNotification'
  waitOn: ->
    Meteor.subscribe 'mobileApps', {},
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}
