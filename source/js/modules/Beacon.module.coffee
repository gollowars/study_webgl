class Beacon
  constructor: ->
    @signal = new signals.Signal()
    @update()

  add: (f, scope = null) ->
    @signal.add f, scope

  update: =>
    @signal.dispatch()
    requestAnimationFrame(@update)




module.exports = new Beacon()