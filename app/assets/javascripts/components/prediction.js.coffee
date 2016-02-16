@Prediction = React.createClass
  render: ->
    React.DOM.tr id: 'prediction_user_' + @props.user + '_match_' + @props.prediction.match_id,
      React.DOM.td null, @props.user
      React.DOM.td id: @props.user + '_' + @props.prediction.match_id + '_' + 'local_goals', @props.prediction.local_goals
      React.DOM.td id: @props.user + '_' + @props.prediction.match_id + '_' + 'visitor_goals', @props.prediction.visitor_goals
      React.DOM.td null, ''
