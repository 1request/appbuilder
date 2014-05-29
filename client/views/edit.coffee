Template.edit.helpers
  mobile: ->
    Mobile.findOne()

Template.edit.events
  'keyup input[name=title]': (e, context) ->
    Mobile.update e.target.dataset.id, $set: {title: e.target.value}

  'keyup input[name=imageUrl]': (e, context) ->
    if /\.(jpg|gif|png)$/.test e.target.value
      Mobile.update e.target.dataset.id, $addToSet: {imageUrls: e.target.value}
      e.target.value = ''
      throwAlert 'image added successfully'
      Meteor.setTimeout ->
        clearAlerts()
      , 1500
      document.getElementById('iphone').contentWindow.location.reload(true)

  'submit form': (e) ->
    e.preventDefault()