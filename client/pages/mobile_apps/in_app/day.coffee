Template.day.helpers
  date: ->
    moment().date(@).format('ddd, Do')
  count: ->
    '&#10004;' if !!Session.get "day#{@.valueOf()}"

Template.day.rendered = ->
  date = @data
  unless moment().date() == @.valueOf()
    Meteor.call 'dayCount', Session.get('deviceId'), Session.get('mobileAppKey'), date, (error, result) ->
      Session.set "day#{date}", result
