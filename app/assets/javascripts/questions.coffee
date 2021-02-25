$(document).on 'turbolinks:load', () ->
  $('.question').on 'click', '.edit-question-link', (event) ->
    event.preventDefault()
    $('.question-data').hide()
    $('#edit-question-form').removeClass('hidden')

  $(".question").on "ajax:success", (e) ->
    details = e.detail[0]
    $("p.rating").html("Rating: #{details['rating']}")
    if details['current_user_voted']
      $('.question a.vote_back').removeClass('hidden');
      $('.question a.vote').addClass('hidden');
    else
      $('.question a.vote').removeClass('hidden');
      $('.question a.vote_back').addClass('hidden');
    return
  App.cable.subscriptions.create "QuestionsChannel",
    connected: ->
      @perform 'follow'
    received: (server_data) ->
      console.log(server_data)
      $(".questions").append(JST["templates/question"](server_data))
