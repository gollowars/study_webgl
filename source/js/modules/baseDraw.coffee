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
    $canvas = $('<canvas id="myCanvas"></canvas>')
    $('#container').append($canvas)
    canvas = $('#myCanvas')[0]
    canvas.width = w
    canvas.height = h
    @gl = canvas.getContext('webgl')
    @gl.clearColor(0.0,0.0,0.0,1.0)
    @gl.clearDepth(1.0)
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

    vs = @gl.createShader @gl.VERTEX_SHADER
    @gl.shaderSource vs, $('#vert').text()
    @gl.compileShader vs

    fs = @gl.createShader @gl.FRAGMENT_SHADER
    @gl.shaderSource fs, $('#frag').text()
    @gl.compileShader fs

    program = @gl.createProgram()
    @gl.attachShader program,vs
    @gl.attachShader program, fs
    @gl.linkProgram program

    if @gl.getProgramParameter program, @gl.LINK_STATUS
      @gl.useProgram program

    else
      console.log @gl.getProgramInfoLog program

    attributeLocation = @gl.getAttribLocation program,'position'
    attributeStribe = 3

    vertexPosition = [
      -1.0,1.0,0.0
      1.0,0.0,0.0
      -1.0,0.0,0.0
    ]

    colorAttributeLocation = @gl.getAttribLocation program,'color'
    colorAttributeStribe = 4
    vertexColor = [
      1.0,0,0,0.0,1.0
      0,0,1.0,0.0,1.0
      1.0,1.0,0,0,0.0
    ]

    #vbo生成
    vbo = @gl.createBuffer()
    @gl.bindBuffer @gl.ARRAY_BUFFER,vbo
    @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(vertexPosition), @gl.STATIC_DRAW

    # vbo登録
    @gl.bindBuffer @gl.ARRAY_BUFFER, vbo
    @gl.enableVertexAttribArray attributeLocation
    @gl.vertexAttribPointer attributeLocation,attributeStribe,@gl.FLOAT,false,0,0


    cVbo = @gl.createBuffer()
    @gl.bindBuffer @gl.ARRAY_BUFFER, cVbo
    @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(vertexColor),@gl.STATIC_DRAW

    
    @gl.bindBuffer @gl.ARRAY_BUFFER, cVbo
    @gl.enableVertexAttribArray colorAttributeLocation
    @gl.vertexAttribPointer colorAttributeLocation, colorAttributeStribe,@gl.FLOAT,false,0,0


    m = new matIV()
    mMatrix = m.identity m.create()
    vMatrix = m.identity m.create()
    pMatrix = m.identity m.create()
    vpMatrix = m.identity m.create()
    mvpMatrix = m.identity m.create()

    m.lookAt [0.0,0.0,5.0], [0,0,0], [0,1,0], vMatrix
    m.perspective 90, w/h, 0.1,100,pMatrix
    m.multiply pMatrix, vMatrix, vpMatrix

    m.translate mMatrix, [1.0,0.0,0.0],mMatrix

    m.multiply vpMatrix, mMatrix, mvpMatrix

    uniLocation = @gl.getUniformLocation program, 'mvpMatrix'
    @gl.uniformMatrix4fv uniLocation, false ,mvpMatrix
    @gl.drawArrays @gl.TRIANGLES, 0, 3


    m.identity mMatrix
    m.translate mMatrix, [-1.5,0.0,0.0], mMatrix
    m.multiply vpMatrix, mMatrix, mvpMatrix


    @gl.uniformMatrix4fv uniLocation, false,mvpMatrix
    @gl.drawArrays @gl.TRIANGLES, 0, 3

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
