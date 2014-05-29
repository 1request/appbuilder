@Alerts = new Meteor.Collection null

@throwAlert = (message) ->
  Alerts.insert {message: message, seen: false}

@clearAlerts = ->
  Alerts.remove {seen: true}

Template.alerts.helpers
  alerts: ->
    Alerts.find()

Template.alert.rendered = ->
  alert = @data
  Meteor.defer ->
    Alerts.update alert._id, $set: {seen: true}