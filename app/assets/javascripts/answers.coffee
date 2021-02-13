$(document).on 'turbolinks:load', () ->
  $('.answers').on 'click', '.edit-answer-link', (event) ->
    event.preventDefault()
    answerId = $(this).data("answerId")
    $('#answer-body-' + answerId).hide()
    $('#edit-answer-' + answerId).show()

  $('.answers').on 'ajax:success', (e) ->
    details = e.detail[0]
    $("#answer-#{details['id']} p.rating").html("Rating: #{details["rating"]}")
    if details['current_user_voted']
      $("#answer-#{details['id']} a.vote_back").removeClass("hidden")
      $("#answer-#{details['id']} a.vote").addClass("hidden")
    else
      $("#answer-#{details['id']} a.vote_back").addClass("hidden")
      $("#answer-#{details['id']} a.vote").removeClass("hidden")