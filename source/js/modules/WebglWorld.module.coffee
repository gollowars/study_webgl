#= require './shaderlib.module'
#= require './Beacon.module'
#= require './SimpleObject.module'

Beacon = require 'modules/Beacon'
ShaderLib = require './shaderlib'
SimpleObject = require './SimpleObject'

module.exports = class World
  constructor: ->
    @canvas = null
    @gl = null

    @time = 0
    @increment = 0.01

    @objSum = 2
    @objArray = []

    @init()
    return
  init: ->

    w = $(window).width()
    h = $(window).height()
    $canvas = $('<canvas id="myCanvas"></canvas>')
    $('#container').append($canvas)
    canvas = $('#myCanvas')[0]
    canvas.width = w
    canvas.height = h
    @gl = canvas.getContext('webgl')
    @gl.clearColor(0.0,0.0,0.0,1.0)
    @gl.clearDepth(1.0)
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT
    

    position = [0.0,0.0,0.0]
    speed = [10.0,10.0,0.0]
    @object = new SimpleObject(@gl,position,speed)
    
    m = new matIV()
    mMatrix = m.identity m.create()
    vMatrix = m.identity m.create()
    pMatrix = m.identity m.create()
    @vpMatrix = m.identity m.create()
    @mvpMatrix = m.identity m.create()

    m.lookAt [0.0,0.0,5.0], [0,0,0], [0,1,0], vMatrix
    m.perspective 90, w/h, 0.1,100,pMatrix
    m.multiply pMatrix, vMatrix, @vpMatrix

    @mvpMatrix = @object.draw(@vpMatrix,@mvpMatrix)

    @gl.flush()

    @animate()
    return

  animate: ->
    requestAnimationFrame(
      =>
        @animate()
        return
    )

    @time += @increment

    @render()

    return

  render:->
    @gl.clearColor(0.0,0.0,0.0,1.0)
    @gl.clearDepth(1.0)
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

    @mvpMatrix = @object.update(@mvpMatrix,@time)

    return
