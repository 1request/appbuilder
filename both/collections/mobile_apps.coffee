@MobileApps = new Meteor.Collection 'mobileApps'

MobileApps.allow
  update: ->
    true