$(document).on 'turbolinks:load', () ->
  $('.question').on 'click','.edit-question-link' ,(event) ->
    event.preventDefault()
    $('.question-data').hide()
    $('#edit-question-form').removeClass('hidden')
