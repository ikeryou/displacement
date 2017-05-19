Util    = require('../libs/Util')
Func    = require('../core/Func')
Conf    = require('../core/Conf')
Param   = require('../core/Param')
Canvas  = require('./Canvas')
Capture = require('./Capture')


class MovieCanvas extends Canvas

  constructor: (opt) ->

    super(opt)

    @_src = opt.src
    @_cap
    @_video
    @_dest
    @_mask
    @_shapes = []
    @_time = 0



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    @camera[0] = @_makeCamera({isOrthographic:false})
    @camera[1] = @_makeCamera({isOrthographic:false}) # 映像用
    @_updatePerspectiveCamera(@camera[0])
    @_updatePerspectiveCamera(@camera[1])

    # 浮動小数点数テクスチャ有効に
    @renderer.extensions.get('OES_texture_float')

    @_cap = new Capture()
    @_cap.init()

    # マスクにつかうMesh
    @_mask = new THREE.Object3D()
    @_cap.add(@_mask)

    # 出力用メッシュ
    @_dest = new THREE.Mesh(
      new THREE.PlaneBufferGeometry(1,1),
      new THREE.ShaderMaterial({
        vertexShader   : require('../../shader/Base.vert')
        fragmentShader : require('../../shader/Movie.frag')
        uniforms:{
          tDiffuse   : {value:@_makeDestTex()}
          tMask      : {value:@_cap.texture()}
          strength   : Param.mask.strength
          showMask   : Param.mask.showMask
          offsetX    : Param.mask.offsetX
          offsetY    : Param.mask.offsetY
        }
      })
    )
    @mainScene.add(@_dest)

    Param.mask.shapeNum.gui.onFinishChange((val) =>
      @_makeShapeMesh(val)
    )
    @_makeShapeMesh(Param.mask.shapeNum.value)



  # -----------------------------------------------
  # マスクかけるテクスチャ
  # -----------------------------------------------
  _makeDestTex: =>

    @_video = document.createElement('video')
    @_video.loop = true

    tex = new THREE.VideoTexture(@_video)
    tex.minFilter = tex.magFilter = THREE.LinearFilter
    tex.format = THREE.RGBFormat
    tex.generateMipmaps = false

    @_video.addEventListener('loadeddata', (e) =>
      @_resize()
    )

    if isMobile.any
      @_video.preload  = 'none'
      @_video.autoplay = false
      @_video.src      = @_src
      @_video.load()
    else
      @_video.src = @_src
      @_video.play()

    return tex



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

      @_time++

      if isMobile.any && @_video.duration > 0
        @_video.currentTime += 0.015
        if @_video.currentTime >= @_video.duration
          @_video.currentTime = 0
        @_dest.material.uniforms.tDiffuse.value.needsUpdate = true

      @_mask.rotation.z = Util.radian(Param.mask.rotation.value)

      # 色更新
      for val,i in @_mask.children
        col = val.material.color
        radian = i * (Param.mask.noise.value * 0.01) + @_time * 0.1
        col.r = Util.map(Math.sin(radian * 0.9), 0, 1, -1, 1)
        col.g = Util.map(Math.cos(radian * 0.7), 0, 1, -1, 1)

        if Param.mask.isBlank.value && i % 2 == 0
          val.visible = false
        else
          val.visible = true


      @_cap.render(@renderer, @camera[1])
      @renderer.render(@mainScene, @camera[0])




  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    w = movW = window.innerWidth
    h = movH = window.innerHeight

    # 画面にFIXするように
    if @_dest? && @_video.duration > 0
      movW = w
      movH = @_video.videoHeight * (movW / @_video.videoWidth)
      if movH < h
        movH = h
        movW = @_video.videoWidth * (movH / @_video.videoHeight)
      @_dest.scale.set(movW, movH, 1)

    @_updatePerspectiveCamera(@camera[0], w, h)
    @_updatePerspectiveCamera(@camera[1], movW, movH)

    @renderer.setPixelRatio(window.devicePixelRatio || 1)
    @renderer.setSize(w, h)
    @renderer.clear()

    @_cap.size(movW, movH)

    size = Math.sqrt(movW * movW + movH * movH)
    for val,i in @_mask.children
      if w > h
        sx = size / @_mask.children.length
        val.scale.set(sx, size, 1)
        val.position.x = i * sx + (sx * 0.5) - (@_mask.children.length * sx * 0.5)
        val.position.y = 0
      else
        sy = size / @_mask.children.length
        val.scale.set(size, sy, 1)
        val.position.x = 0
        val.position.y = i * sy + (sy * 0.5) - (@_mask.children.length * sy * 0.5)



  # -----------------------------------------------
  # マスク用のメッシュ作る
  # -----------------------------------------------
  _makeShapeMesh: (num) =>

    # 一旦消す
    for val,i in @_shapes
      @_mask.remove(val)
      val.geometry.dispose()
      val.material.dispose()
    @_shapes = []

    i = 0
    num = ~~(num)
    while i < num
      shape = new THREE.Mesh(
        new THREE.PlaneBufferGeometry(1,1),
        new THREE.MeshBasicMaterial({
          color:0x000000
        })
      )
      @_shapes.push(shape)
      @_mask.add(shape)
      i++

    @_resize()















module.exports = MovieCanvas
