#= require './shaderlib.module'
#= require './Beacon.module'

Beacon = require 'modules/Beacon'
ShaderLib = require './shaderlib'

module.exports = class World
  constructor: ->
    @container = null
    @scene = null
    @camera = null
    @renderer = null
    @cube = null
    @boxList = []

    @group = null


    # block
    @groundSize = 10
    @groundDivide = 10
    @boxSize = 1

    @strength = 1.0

    @mouse = new THREE.Vector2( 0, 0 )

    @init()
    @animate()
    return
  init: ->
    w = window.innerWidth
    h = window.innerHeight
    # camera
    @camera = new THREE.PerspectiveCamera( 64, w / h, 0.1, 2000 )
    @camera.position.z = 1000
    # scene
    @scene = new THREE.Scene()


    # mouse
    @mouse = new THREE.Vector2()

    # clock
    @clock = new THREE.Clock()


    # geometry
    @geometry = new THREE.PlaneGeometry( w, h, 4, 4 )

    @uniform1 =
      time: { type: 'f', value: 1.0 }
      resolution: { type: 'v2', value: new THREE.Vector2( w, h ) }
      mouse: { type: 'v2', value: new THREE.Vector2( 0, 0 ) }
      strength: {type: 'f', value: @strength}


    @material = new THREE.RawShaderMaterial
      uniforms: @uniform1
      #vertexShader: document.getElementById( 'vert' ).textContent
      vertexShader: document.getElementById('default-vert').textContent
      fragmentShader: ShaderLib.createFrag([ShaderLib.noise2d, ShaderLib.noise3d + document.getElementById( 'frag' ).textContent])

    @mesh = new THREE.Mesh( @geometry, @material )
    @scene.add( @mesh )

    @camera.lookAt(@mesh.position)


    # renderer
    @renderer = new THREE.WebGLRenderer()
    # @renderer.setPixelRatio( window.devicePixelRatio )
    @renderer.setSize( w, h )
    document.body.appendChild(@renderer.domElement)

    # add event listener
    # $( window ).on('mousemove', @mousemove)
    console.log w, window.innerWidth


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

    sw = window.innerWidth
    sh = window.innerHeight
    delta = @clock.getDelta()
    @uniform1.time.value += delta * 0.2

    @renderer.render(@scene,@camera)

    return


  createBgShader:()->
    # geometry
    @sgeo = new THREE.PlaneGeometry( window.innerWidth, window.innerHeight, 4, 4 )

    @uniform1 =
      time: { type: 'f', value: 1.0 }
      resolution: { type: 'v2', value: new THREE.Vector2( window.innerWidth, window.innerHeight ) }
      mouse: { type: 'v2', value: new THREE.Vector2( 0, 0 ) }
      strength: {type: 'f', value: @strength}


    @smat = new THREE.RawShaderMaterial
      uniforms: @uniform1
      #vertexShader: document.getElementById( 'vert' ).textContent
      vertexShader: document.getElementById('default-vert').textContent
      fragmentShader: ShaderLib.createFrag([ShaderLib.noise2d, ShaderLib.noise3d + document.getElementById( 'frag' ).textContent])

    @shader = new THREE.Mesh( @sgeo, @smat )
    @shader.position.z = -900
    @scene.add( @shader )
    return


  loadTexture:()->
    console.log 'load Start!'
    loader = new THREE.TextureLoader()
    loader.load './images/sample.jpg',(texture)=>
      console.log 'load complete!!'
      @createObject(texture)
      return

    return

  createObject:(texture)=>
    colog = 0x000000
    # thumbnail
    thumbGeo = new THREE.PlaneGeometry @movObjW, @movObjH, 0, 0
    thumbMat = MAT.clone()
    imgw = cellw = @thumbTexture.image.width
    imgh = cellh = @thumbTexture.image.height
    uUnit = 1
    vUnit = 1
    if @isSprite is true
      cellw = 300
      cellh = 169
      uUnit = cellw / imgw
      vUnit = cellh / imgh
      material.uniforms.cellsize.value.x = uUnit
      material.uniforms.cellsize.value.y = vUnit
      material.uniforms.offset.value = 10 / imgh

    thumbMat.uniforms.texture.value = @thumbTexture
    thumbMat.uniforms.cover.value.setHex(color)
    @thumbMat = thumbMat
    @thumbMesh = new THREE.Mesh THUMBNAIL_PLANE, thumbMat
    @.add @thumbMesh

    # mesh = new THREE.Mesh geometory, material
    # mesh.position.z = -30
    # @scene.add mesh

    return


  touchupHandler:(e)=>
    if e.target is @renderer.domElement
      @mouse.x = (e.changedTouches[0].pageX/ window.innerWidth)*2-1
      @mouse.y = -(e.changedTouches[0].pageY/ window.innerHeight)*2+1

      ## マウスベクトル
      @raycaster.setFromCamera( @mouse, @camera )

      ## クリック判定
      intersects = @raycaster.intersectObjects( [@mesh],true )
      console.log intersects.length

      # obj = @raycaster.intersectObject ( @scene.children )
    return


  clickHandler:(event)=>
    mouse = new THREE.Vector2( 0, 0 )
    mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1
    mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1
    
    @raycaster.setFromCamera(mouse,@camera)
    intersects = @raycaster.intersectObjects( [@mesh], true )
    console.log 'click!'
    console.log mouse.x
    console.log intersects.length

    return