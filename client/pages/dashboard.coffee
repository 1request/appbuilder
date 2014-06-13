Template.dashboard.created = ->
  Session.setDefault 'selectedMobileId', Mobile.findOne()._id
  Session.setDefault 'selectedDeviceId', Members.findOne(appId: Session.get 'selectedMobileId').deviceId