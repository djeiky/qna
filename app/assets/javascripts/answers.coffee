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

  App.cable.subscriptions.create "AnswersChannel",
    connected: ->
      @perform 'follow', question: gon.question
    received: (server_data) ->
      if server_data.answer && !( gon.current_user && server_data.answer.user_id == gon.current_user.id)
        $('.answers').append(JST["templates/answer"](server_data))
