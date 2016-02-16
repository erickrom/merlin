@PredictionForm = React.createClass
  getInitialState: ->
    console.log('I am in getInitialState of prediction form')
    local_goals: ''
    visitor_goals: ''
    tournament_id: @props.tournament_id
    match_id: @props.match_id
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '/predictions', { prediction: @state }, (data) =>
      @props.handleNewPrediction data
      @setState @getInitialState()
    , 'JSON'
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Local Goals'
          name: 'local_goals'
          value: @state.local_goals
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Visitor Goals'
          name: 'visitor_goals'
          onChange: @handleChange
          value: @state.visitor_goals
        React.DOM.input
          type: 'hidden'
          name: 'tournament_id'
          value: @state.tournament_id
        React.DOM.input
          type: 'hidden'
          name: 'match_id'
          value: @state.match_id
        React.DOM.button
          type: 'submit'
          className: 'btn btn-primary'
          disabled: !@valid()
          'Add prediction'
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  valid: ->
    @state.local_goals && @state.visitor_goals
