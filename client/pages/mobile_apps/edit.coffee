updateStatus = (status) ->
  app = MobileApps.findOne(appKey: Session.get('mobileAppKey'))
  modifier =
    $set:
      status:
        status
  MobileApps.update app._id, modifier, (error, result) ->
    throwAlert 'App status updated. Please remember to update certificate accordingly'

setStatus = (status) ->
  $("#production").prop('checked', false)
  $("#development").prop('checked', false)
  $("##{status}").prop('checked', true)

setDropZone = (callback) ->
  dropzoneOptions =
    addRemoveLinks: true
    acceptedFiles: '.p12'
    maxFiles: 1

  dropZone = new Dropzone('#dropzone', dropzoneOptions)

  dropZone.on 'addedfile', (file) ->
    P12s.insert file, (error, fileObj) ->
      Session.set 'p12', fileObj._id
      mobileApp = MobileApps.findOne(appKey: Session.get('mobileAppKey'))
      MobileApps.update(mobileApp._id, {$set: {p12: fileObj._id}})

  dropZone.on 'success', (file) ->
    callback()

Template.editMobileApp.helpers
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get 'mobileAppKey')
  deviceId: ->
    Session.get 'deviceId'
  path: ->
    Router.routes['mobileApp'].path({deviceId: Session.get('deviceId'), appKey: Session.get('mobileAppKey')})
  showDropZone: ->
    Session.get('showDropZone')

Template.editMobileApp.rendered = ->

  app = MobileApps.findOne()

  @editMobileAppDep = Deps.autorun ->
    if MobileApps.findOne()
      Session.setDefault('mobileAppKey', MobileApps.findOne().appKey)
      app = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
      Session.set('deviceId', MobileAppUsers.findOne(appKey: Session.get 'mobileAppKey').deviceId)
      $('#selected-app').val("#{Session.get 'mobileAppKey'}")
      Session.set('status', app.status)
      setStatus(app.status)

Template.editMobileApp.events
  'keyup input[name=name]': (e, context) ->
    MobileApps.update e.target.dataset.id, $set: {name: e.target.value}

  'keyup input[name=imageUrl]': (e, context) ->
    if /\.(jpg|gif|png)$/.test e.target.value
      MobileApps.update e.target.dataset.id, $addToSet: {imageUrls: e.target.value}
      e.target.value = ''
      throwAlert 'image added successfully'
      Meteor.setTimeout ->
        clearAlerts()
      , 1500
      document.getElementById('iphone').contentWindow.location.reload(true)

  'change #certificate': (e, context) ->
    if $(e.target).is(':checked')
      Session.set('showDropZone', true)
    else
      Session.set('showDropZone', false)

  'click #development': (e, context) ->
    updateStatus('development')

  'click #production': (e, context) ->
    updateStatus('production')

  'submit form': (e) ->
    e.preventDefault()

Template.editMobileApp.destroyed = ->
  if @editMobileAppDep then @editMobileAppDep.stop()
  delete Session.keys['p12']

Template.p12DropZone.rendered = ->
  @p12Dep = ->
    Deps.autorun (computation) ->
      p12 = P12s.findOne(Session.get 'p12')
      if p12 and p12.hasStored('p12s')
        Meteor.call 'transformP12', p12._id, (error, result) ->
          if result
            if result.error then throwAlert result.error
            if result.response then throwAlert result.response
          computation.stop()

  setDropZone(@p12Dep)