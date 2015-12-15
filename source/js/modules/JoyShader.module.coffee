#= require './shaderlib.module'

module.exports = 
  class JoyShader
    constructor:(@gl)->
      @shader = null
      @scriptElement = null

      return

    createShader:(@id)->
      @scriptElement = document.getElementById(@id)

      switch @scriptElement.type
        when 'x-shader/x-vertex'
          @shader = @gl.createShader(@gl.VERTEX_SHADER)
        when 'x-shader/x-fragment'
          @shader = @gl.createShader(@gl.FRAGMENT_SHADER)
        else
          return

      @gl.shaderSource @shader,@scriptElement.text
      @gl.compileShader @shader
      if @gl.getShaderParameter @shader, @gl.COMPILE_STATUS
        console.log 'complete compile'
        return @shader
      else
        console.log @gl.getShaderInfoLog @shader
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


    createVbo:(data)->
      vbo = @gl.createBuffer()
      @gl.bindBuffer @gl.ARRAY_BUFFER, vbo
      @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(data), @gl.STATIC_DRAW
      @gl.bindBuffer(@gl.ARRAY_BUFFER, null)
      return vbo