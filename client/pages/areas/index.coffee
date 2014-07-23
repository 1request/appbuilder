Template.areas.helpers
  areas: ->
    Areas.find({}, sort: {createdAt: 1})

Template.area.helpers
  url: ->
    Images.findOne(@image).url(store: 'thumbs') if !!@image