Notifications.new = AppController.extend
  template: 'newNotification'
  waitOn: ->
    Meteor.subscribe 'mobileApps', {},
    Meteor.subscribe 'notifications', {appKey: Session.get('mobileAppKey')}
