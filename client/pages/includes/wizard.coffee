Template.wizard.helpers
  hasApp: ->
    !!MobileApps.find().count()
  hasBeacon: ->
    hasBeacon = HasBeacons.findOne()
    hasBeacon.hasBeacons if hasBeacon

Template.wizard.rendered = ->
  $('html').addClass('fuelux')
  $wizard = $('#wizard').wizard()
  wizard = $wizard.data('wizard')
  $wizard.off('click', 'li.complete')
  $wizard.on('click', 'li', $.proxy(wizard.stepclicked, wizard))

  @hasBeaconsDep = Deps.autorun ->
    hasBeacon = HasBeacons.findOne()

    if hasBeacon
      if Router.current().path is '/areas'
        $('#wizard').wizard('selectedItem', {step: 3})
      else if hasBeacon.hasBeacons
        $('#wizard').wizard('selectedItem', {step: 4})
      else if MobileApps.findOne()
        $('#wizard').wizard('selectedItem', {step: 2})
      else
        $('#wizard').wizard('selectedItem', {step: 1})

Template.wizard.destroyed = ->
  if @hasBeaconsDep
    @hasBeaconsDep.stop()