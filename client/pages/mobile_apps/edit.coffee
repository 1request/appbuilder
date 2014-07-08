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
  selectedZones: ->
    if Session.get 'selectedZones'
      _.pluck(Zones.find(text: {$in: Session.get 'selectedZones'}).fetch(), 'text').join(',')

Template.editMobileApp.rendered = ->

  @editMobileAppDep = Deps.autorun ->
    if MobileApps.findOne()
      Session.setDefault('mobileAppKey', MobileApps.findOne().appKey)
      app = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
      Session.set('deviceId', MobileAppUsers.findOne(appKey: Session.get 'mobileAppKey').deviceId)
      $('#selected-app').val("#{Session.get 'mobileAppKey'}")
      runSelect2(Session.get('selectedZones'))

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

  'submit form': (e) ->
    e.preventDefault()

Template.editMobileApp.destroyed = ->
  if @editMobileAppDep then @editMobileAppDep.stop()
  delete Session.keys['p12']
