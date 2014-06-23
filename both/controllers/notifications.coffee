Notifications.new = AppController.extend
  template: 'newNotification'
  waitOn: ->
    Meteor.subscribe 'mobileApps', {}
