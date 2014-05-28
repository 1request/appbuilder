Template.edit.helpers
  mobile: ->
    Mobile.findOne()

Template.edit.events
  'change input[name=title]': (e, context) ->
    Mobile.update e.target.dataset.id, $set: {title: e.target.value}

  'submit form': (e) ->
    e.preventDefault()