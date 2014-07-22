Template.areas.helpers
  areas: ->
    Areas.find({}, sort: {createdAt: 1})

Template.area.helpers
  url: ->
    Images.findOne(@imageId).url(store: 'thumbs') if !!@imageId