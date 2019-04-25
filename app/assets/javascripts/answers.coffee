$(document).on 'turbolinks:load', () ->
  $('.answers').on 'click','.edit-answer-link' ,(event) ->
    event.preventDefault()
    answerId = $(this).data("answerId")
    $('#answer-body-' + answerId).hide()
    $('#edit-answer-' + answerId).show()
