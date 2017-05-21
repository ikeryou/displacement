Util    = require('../libs/Util')
Func    = require('../core/Func')
Conf    = require('../core/Conf')
Param   = require('../core/Param')
Canvas  = require('./Canvas')
Capture = require('./Capture')


class MovieCanvas extends Canvas

  constructor: (opt) ->

    super(opt)

    @_cap = []
    @_dest
    @_mask
    @_shapes = []
    @_light = []
    @_mesh0 = []
    @_mesh1 = []
    @_speed = []
    @_time = 0

    @_video



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

    @_light[0] = new THREE.PointLight(0xffffff, 1, 0)
    @_light[1] = new THREE.PointLight(0xffffff, 1, 0)

    # 0..マスク
    # 1..キューブ
    # 2..まる
    i = 0
    while i < 3
      cap = new Capture()
      cap.init()
      @_cap.push(cap)
      i++

    # マスクにつかうMesh
    @_mask = new THREE.Object3D()
    @_cap[0].add(@_mask)

    @_makeTg()

    # 出力用メッシュ
    @_dest = new THREE.Mesh(
      new THREE.PlaneBufferGeometry(1,1),
      new THREE.ShaderMaterial({
        vertexShader   : require('../../shader/Base.vert')
        fragmentShader : require('../../shader/Movie.frag')
        uniforms:{
          tDiffuse0  : {value:@_cap[1].texture()}
          tDiffuse1  : {value:@_cap[2].texture()}
          tMask      : {value:@_cap[0].texture()}
          # tMov       : {value:@_makeDestTex()}
          strength   : Param.mask.strength
          showMask   : Param.mask.showMask
          showDiffuse0   : Param.mask.showDiffuse0
          showDiffuse1  : Param.mask.showDiffuse1
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

    @_resize()



  # -----------------------------------------------
  # マスクかけるやつ
  # -----------------------------------------------
  _makeTg: =>

    @_cap[1].add(@_light[0])
    @_cap[2].add(@_light[1])

    i = 0
    num = 20
    while i < num

      mesh0 = new THREE.Mesh(
        # new THREE.BoxBufferGeometry(1,1,1),
        new THREE.DodecahedronBufferGeometry(0.5,0),
        new THREE.MeshPhongMaterial({
          color:0xed6557
          # emissive: 0xffffff
          shading: THREE.FlatShading
        })
      )
      @_cap[1].add(mesh0)
      @_mesh0.push(mesh0)
      @_speed[0] = 0

      mesh1 = new THREE.Mesh(
        # new THREE.BoxBufferGeometry(1,1,1)
        # new THREE.DodecahedronBufferGeometry(0.5,0.5),
        new THREE.DodecahedronBufferGeometry(0.5,0),
        new THREE.MeshPhongMaterial({
          color:0x53c0f1
          # emissive: 0x000000
          shading: THREE.FlatShading
        })
      )
      @_cap[2].add(mesh1)
      @_mesh1.push(mesh1)
      @_speed[1] = 0

      i++




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
      @_video.src = '/assets/movie/test.mp4'
      @_video.play()

    return tex



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    @_time++

    add = 0.01
    @_speed[0] += add
    @_speed[1] += add

    # if isMobile.any && @_video.duration > 0
    #     @_video.currentTime += 0.015
    #     if @_video.currentTime >= @_video.duration
    #       @_video.currentTime = 0
    #     @_dest.material.uniforms.tMov.value.needsUpdate = true

    # @_mask.rotation.z = Util.radian(Param.mask.rotation.value)
    #@_mask.rotation.z = Util.radian(Param.mask.rotation.value)
    radian = @_time * 0.0001
    @_mask.rotation.z = Math.sin(radian) * 45

    # 色更新
    for val,i in @_mask.children
      col = val.material.color
      radian = i * (Param.mask.noise.value * 0.01) + @_time * 0.1
      if Param.mask.moveRG.value
        col.r = Util.map(Math.sin(radian * 0.9), 0, 1, -1, 1)
        col.g = Util.map(Math.cos(radian * 0.7), 0, 1, -1, 1)
      else
        col.r = 0
        col.g = 0
      if Param.mask.moveB.value
        col.b = Util.map(Math.sin(radian * 0.75), 0, 1, -1, 1)
      else
        col.b = i % 2


    for val,i in @_mesh0

      mesh0 = val
      mesh1 = @_mesh1[i]

      radian0 = Util.radian(@_speed[0])
      mesh0.rotation.set(
        Math.sin(radian0 * 1.0) * 45,
        Math.cos(radian0 * 0.9) * 45,
        Math.sin(radian0 * 1.2) * 45
      )

      radian1 = Util.radian(@_speed[1])
      mesh1.rotation.set(
        Math.sin(radian1 * 1.0) * 45,
        Math.cos(radian1 * 0.9) * 45,
        Math.sin(radian1 * 1.2) * 45
      )
      #mesh1.rotation.copy(mesh0.rotation)


    for val,i in @_cap
      val.render(@renderer, @camera[1])

    @renderer.render(@mainScene, @camera[0])



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    w = window.innerWidth
    h = window.innerHeight

    movW = movH = Math.max(w, h)

    @_dest.scale.set(movW, movH, 1)

    @_updatePerspectiveCamera(@camera[0], w, h)
    @_updatePerspectiveCamera(@camera[1], movW, movH)

    @renderer.setPixelRatio(window.devicePixelRatio || 1)
    @renderer.setSize(w, h)
    @renderer.clear()

    @_resizeMaskTg()

    @_light[0].position.set(0, movW * 2, movW * 2)
    @_light[1].position.set(0, -movW * 2, movW * 2)

    for val,i in @_cap
      val.size(movW, movH)

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
  # マスクかけるやつリサイズ
  # -----------------------------------------------
  _resizeMaskTg: =>

    w = window.innerWidth
    h = window.innerHeight

    for val,i in @_mesh0

      mesh0 = val
      mesh1 = @_mesh1[i]

      p = new THREE.Vector3(
        Util.random(-w * 0.5, w * 0.5),
        Util.random(-h * 0.5, h * 0.5),
        0
      )

      s = Math.min(w, h) * Util.random(0.2, 0.5)
      mesh0.scale.set(s, s, s)
      mesh1.scale.set(s, s, s)

      mesh0.position.copy(p)

      p = new THREE.Vector3(
        Util.random(-w * 0.5, w * 0.5),
        Util.random(-h * 0.5, h * 0.5),
        0
      )
      mesh1.position.copy(p)



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
      color = new THREE.Color()
      color.b = (i % 2)
      shape = new THREE.Mesh(
        new THREE.PlaneBufferGeometry(1,1),
        new THREE.MeshBasicMaterial({
          color:color
        })
      )
      @_shapes.push(shape)
      @_mask.add(shape)
      i++

    @_resize()















module.exports = MovieCanvas
