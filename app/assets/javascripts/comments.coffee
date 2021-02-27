App.cable.subscriptions.create 'CommentsChannel',
  connected: ->
    @perform 'follow', question_id: gon.question.id
  received: (data) ->
    if data.comment.commentable_type == 'Question'
      $('.question .comments').append JST['templates/comment'](data)
    if data.comment.commentable_type == 'Answer'
      $("#answer-#{data.comment.commentable_id} .comments").append JST['templates/comment'](data)
