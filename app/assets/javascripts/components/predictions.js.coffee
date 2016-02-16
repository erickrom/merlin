@Predictions = React.createClass
  getInitialState: ->
    predictions: @props.data.predictions
    users: @props.data.users
  getDefaultProps: ->
    predictions: []
  addPrediction: (prediction) ->
    predictions = @state.predictions.slice()
    console.log("*** PREDICTION: " + prediction.user_name)
    predictions.push prediction.prediction
    users = @state.users.slice()
    users.push prediction.user_name
    @setState predictions: predictions, users: users
  render: ->
    React.DOM.div
      className: 'predictions'
      React.DOM.h5
        className: 'title'
        'Predictions'
      React.createElement PredictionForm, tournament_id: @props.data.tournament_id, match_id: @props.data.match_id, handleNewPrediction: @addPrediction
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Player'
            React.DOM.th null, 'Local Goals'
            React.DOM.th null, 'Visitor Goals'
            React.DOM.th null, 'Points'
        React.DOM.tbody null,
          for prediction, i in @state.predictions
            React.createElement Prediction, key: prediction.id, prediction: prediction, user: @state.users[i]
