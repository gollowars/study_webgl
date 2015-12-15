#= require './shaderlib.module'
#= require './Beacon.module'
#= require './JoyShader.module'

Beacon = require 'modules/Beacon'
ShaderLib = require './shaderlib'
JoyShader = require './JoyShader'

module.exports = class World
  constructor: ->
    @canvas = null
    @gl = null

    @init()
    return
  init: ->
    w = $(window).width()
    h = $(window).height()

    $('#container').append("<canvas id='canvas' width='#{w}' height='#{h}'></canvas>")


    canvas = $('#canvas')[0]
    @gl = canvas.getContext('webgl')
    @gl.clearColor(0.0,0.0,0.0,1.0)
    @gl.clearDepth(1.0)
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

    joyShader = new JoyShader(@gl)
    vShader = joyShader.createShader('vert')
    fShader = joyShader.createShader('frag')
    program = joyShader.createProgram(vShader,fShader)


    attLocation = @gl.getAttribLocation(program, 'position')
    attStride = 3
    vertexPosition = [
       0.0, 1.0, 0.0
       1.0, 0.0, 0.0
      -1.0, 0.0, 0.0
    ]

    vbo = joyShader.createVbo vertexPosition

    @gl.bindBuffer(@gl.ARRAY_BUFFER, vbo)

    @gl.enableVertexAttribArray attLocation

    @gl.vertexAttribPointer(attLocation, attStride, @gl.FLOAT, false, 0, 0)

    m = new matIV()
    mMatrix = m.identity m.create()
    vMatrix = m.identity m.create()
    pMatrix = m.identity m.create()
    mvpMatrix = m.identity m.create()

    m.lookAt([0.0,1.0,3.0],[0,0,0],[0,1,0],vMatrix)
    m.perspective 90, canvas.width / canvas.height, 0.1, 100, pMatrix    

    m.multiply pMatrix, vMatrix, mvpMatrix
    m.multiply mvpMatrix, mMatrix, mvpMatrix

    uniLocation = @gl.getUniformLocation program, 'mvpMatrix'
    resolution = [new Float32Array(w),new Float32Array(h)]
    @gl.uniformMatrix4fv uniLocation, false, mvpMatrix, resolution

    @gl.drawArrays(@gl.TRIANGLES, 0, 3)

    @gl.flush()

    @animate()
    return

  animate: ->
    requestAnimationFrame(
      =>
        @animate()
        return
    )

    @render()

    return

  render:->

    return
