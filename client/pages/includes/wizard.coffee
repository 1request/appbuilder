Template.wizard.rendered = ->
  $('html').addClass('fuelux')
  $wizard = $('#wizard').wizard()
  wizard = $wizard.data('wizard')
  $wizard.off('click', 'li.complete')
  $wizard.on('click', 'li', $.proxy(wizard.stepclicked, wizard))