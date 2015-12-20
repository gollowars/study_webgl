#= require './shaderlib.module'

module.exports = 
  class SimpleObject
    constructor:(@gl,@position,@speed)->
      @m = new matIV()
      @mMatrix = @m.identity @m.create()
      @vsContext = $('#vert').text()
      @fsContext = $('#frag').text()
      @vertexPosition = [
        0.0,2.0,0.0
        2.0,0.0,0.0
        -2.0,0.0,0.0
      ]

      @colorMatrix = [
        0.0,0.0,0.5,1.0
        0.0,0.5,0.0,1.0
        0.5,0.0,0.0,1.0
      ]

      @x = @position[0]
      @y = @position[1]
      @z = @position[2]

      @init()
      return

    init:()->

      @vs = @createShader('vert',@vsContext)
      @fs = @createShader('frag',@fsContext)
      @program = @createProgram(@vs,@fs)

      @attrLocate = @gl.getAttribLocation @program,'position'
      @attrStribe = 3
      @vbo = @createBuffer(@vertexPosition,@attrLocate,@attrStribe)

    
      @colorLocate = @gl.getAttribLocation @program, 'color'
      @colorStribe = 4
      @colorVbo = @createBuffer(@colorMatrix,@colorLocate,@colorStribe)
      return


    createShader:(type,context)->
      if type is 'vert'
        shader = @gl.createShader @gl.VERTEX_SHADER
      else 
        shader = @gl.createShader @gl.FRAGMENT_SHADER

      @gl.shaderSource shader,context
      @gl.compileShader shader

      if @gl.getShaderParameter shader, @gl.COMPILE_STATUS
        return shader
      else
        console.log @gl.getShaderInfoLog shader
        return

    createProgram:(vs,fs)->
      program = @gl.createProgram()
      @gl.attachShader program, vs
      @gl.attachShader program, fs
      @gl.linkProgram program
      if @gl.getProgramParameter program, @gl.LINK_STATUS
        @gl.useProgram program
        return program
      else
        console.log @gl.getProgramInfoLog program
        return

    createBuffer:(data,locate,stribe)->
      # buffer の生成
      vbo = @gl.createBuffer()
      @gl.bindBuffer @gl.ARRAY_BUFFER, vbo
      @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(data), @gl.STATIC_DRAW
      @gl.bindBuffer @gl.ARRAY_BUFFER, null

      # buffer の登録
      @gl.bindBuffer @gl.ARRAY_BUFFER, vbo
      @gl.enableVertexAttribArray locate
      @gl.vertexAttribPointer locate,stribe,@gl.FLOAT,false,0,0
      return vbo

    draw:(@vpMatrix,mvpMatrix)->
      @m.translate @mMatrix, @position, @mMatrix
      @m.multiply @vpMatrix, @mMatrix, mvpMatrix

      @uniLocation = @gl.getUniformLocation @program, 'mvpMatrix'
      @gl.uniformMatrix4fv @uniLocation, false, mvpMatrix
      @gl.drawArrays @gl.TRIANGLES, 0, 3

      return mvpMatrix


    update:(mvpMatrix,@time)->
      @position[0] = Math.sin(@time*@speed[0])*0.1
      @position[1] = Math.cos(@time*@speed[1])*0.1
      @position[2] = Math.sin(@time*@speed[1])*0.1


      @draw(@vpMatrix,mvpMatrix)
