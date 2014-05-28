@Mobile = new Meteor.Collection 'mobile'

Mobile.allow
  update: ->
    true