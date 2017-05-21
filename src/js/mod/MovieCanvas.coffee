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

    # @_light[0] = new THREE.PointLight(0xffffff, 1, 0)
    # @_light[1] = new THREE.PointLight(0xffffff, 1, 0)

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
          kake    : Param.mask.kake
        }
      })
    )
    @mainScene.add(@_dest)

    Param.mask.shapeNum.gui.onFinishChange((val) =>
      @_resize()
    )
    @_makeShapeMesh(Param.mask.shapeNum.value)

    @_resize()



  # -----------------------------------------------
  # マスクかけるやつ
  # -----------------------------------------------
  _makeTg: =>

    # @_cap[1].add(@_light[0])
    # @_cap[2].add(@_light[1])

    @_disposeTg()

    @_speed[0] = 0
    @_speed[1] = 0

    # size = Math.sqrt(movW * movW + movH * movH)
    # for val,i in @_mask.children
    #   if w > h
    #     sx = size / @_mask.children.length
    #     val.scale.set(sx, size, sx)
    #     val.position.x = i * sx + (sx * 0.5) - (@_mask.children.length * sx * 0.5)
    #     val.position.y = 0
    #   else

    @_cap[1].rotation.z = Util.radian(45)
    @_cap[2].rotation.z = Util.radian(-45)

    w = window.innerWidth
    h = window.innerHeight
    movW = movH = Math.max(w, h)
    size = Math.sqrt(movW * movW + movH * movH)

    i = 0
    num = ~~(Param.mask.shapeNum.value)
    while i < num

      mesh0 = @_makeBasinMesh([0x537e74,0xdc6043][i%2], @_cap[1], @_mesh0)
      mesh1 = @_makeBasinMesh([0x3d6fa0,0xf3c239][i%2], @_cap[2], @_mesh1)

      sy = size / num
      mesh0.scale.set(size, sy, sy)
      mesh0.position.x = 0
      mesh0.position.y = i * sy + (sy * 0.5) - (num * sy * 0.5)

      mesh1.scale.copy(mesh0.scale)
      mesh1.position.copy(mesh0.position)

      i++


    @_cap[1].render(@renderer, @camera[1])
    @_cap[2].render(@renderer, @camera[1])



    # radius = 0
    # max = Math.min(window.innerWidth, window.innerHeight)
    # interval = max * 0.1
    # scale = interval * 0.5
    # while radius < max
    #
    #   circ = radius * 2 * Math.PI
    #   num = ~~(circ / 40)
    #   i = 0
    #   while i < num
    #
    #     mesh0 = @_makeBasinMesh(0xefde6d, @_cap[1], @_mesh0)
    #     mesh1 = @_makeBasinMesh(0x52b380, @_cap[2], @_mesh1)
    #
    #     radian0 = Util.radian(360 / num * i)
    #     radian1 = Util.radian(90 + 360 / num * i)
    #
    #     mesh0.position.set(
    #       Math.sin(radian0) * radius,
    #       Math.cos(radian0) * radius,
    #       0
    #     )
    #
    #     mesh1.position.set(
    #       Math.sin(radian1) * (radius + interval * 0.5),
    #       Math.cos(radian1) * (radius + interval * 0.5),
    #       0
    #     )
    #
    #     mesh0.scale.set(scale * 2, scale * 0.5, 1)
    #     mesh0.rotation.z = 45
    #
    #     mesh1.scale.copy(mesh0.scale)
    #     #mesh1.position.copy(mesh0.position)
    #     mesh1.rotation.copy(mesh0.rotation)
    #
    #     i++
    #
    #   radius += interval
    #
    # console.log(@_mesh0.length)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _disposeTg: =>

    for val,i in @_mesh0
      @_cap[1].remove(val)
      val.geometry.dispose()
      val.material.dispose()
    @_mesh0 = []

    for val,i in @_mesh1
      @_cap[2].remove(val)
      val.geometry.dispose()
      val.material.dispose()
    @_mesh1 = []



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _makeBasinMesh: (color, scene, list) =>


    color = new THREE.Color(color)
    #color.lerp(new THREE.Color(0x000000), Util.random(0, 1))

    mesh = new THREE.Mesh(
      # new THREE.DodecahedronBufferGeometry(0.5,0),
      # new THREE.PlaneBufferGeometry(1,1),
      new THREE.PlaneBufferGeometry(1,1),
      new THREE.MeshBasicMaterial({
        color:color
      })
    )

    scene.add(mesh)
    list.push(mesh)

    return mesh



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
    radian = @_time * 0.01
    # @_mask.rotation.x = Math.sin(radian * 1.0) * 45
    # @_mask.rotation.y = Math.cos(radian * 0.9) * 45
    @_mask.rotation.z = Util.radian(Func.sin2(radian * 1.1) * 45)

    # 色更新
    for val,i in @_mask.children
      col = val.material.color
      radian = i * (Param.mask.noise.value * 0.001) + @_time * 0.05
      if Param.mask.moveRGB.value
        col.r = Util.map(Math.sin(radian * 0.9), 0, 1, -1, 1)
        col.g = Util.map(Math.cos(radian * 0.7), 0, 1, -1, 1)
        col.b = Util.map(Math.sin(radian * 0.75), 0, 1, -1, 1)
        # col.a = Util.map(Math.sin(radian * 0.55), 0, 1, -1, 1)
      else
        col.r = i % 2
        col.g = i % 2
        col.b = i % 2
        col.a = i % 2





    # for val,i in @_mesh0
    #
    #   mesh0 = val
    #   mesh1 = @_mesh1[i]
    #
    #   radian0 = Util.radian(@_speed[0])
    #   mesh0.rotation.set(
    #     Math.sin(radian0 * 1.0) * 45,
    #     Math.cos(radian0 * 0.9) * 45,
    #     Math.sin(radian0 * 1.2) * 45
    #   )
    #
    #   radian1 = Util.radian(@_speed[1])
    #   # mesh1.rotation.set(
    #   #   Math.sin(radian1 * 1.0) * 45,
    #   #   Math.cos(radian1 * 0.9) * 45,
    #   #   Math.sin(radian1 * 1.2) * 45
    #   # )
    #   mesh1.rotation.copy(mesh0.rotation)


    for val,i in @_cap
      if i == 0
        val.render(@renderer, @camera[1])

    # @_cap[0].render(@renderer, @camera[1])
    #
    # if @_time % 2 == 0 then @_cap[1].render(@renderer, @camera[1])
    # if @_time % 2 != 0 then @_cap[2].render(@renderer, @camera[1])

  #  @_cap[1].rotation.z += 0.005
  #  @_cap[2].rotation.z -= 0.005

    #
    # for val,i in @_cap
    #   if i == 0
    #     val.render(@renderer, @camera[1])
    #   else
    #     if

    @renderer.render(@mainScene, @camera[0])



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    w = window.innerWidth
    h = window.innerHeight

    # movW = w
    # movH = h
    movW = movH = Math.max(w, h)

    @_dest.scale.set(movW, movH, 1)

    @_updatePerspectiveCamera(@camera[0], w, h)
    @_updatePerspectiveCamera(@camera[1], movW, movH)

    @renderer.setPixelRatio(window.devicePixelRatio || 1)
    @renderer.setSize(w, h)
    @renderer.clear()



    # @_light[0].position.set(0, movW * 2, movW * 2)
    # @_light[1].position.set(0, -movW * 2, movW * 2)

    for val,i in @_cap
      val.size(movW, movH)

    @_makeTg()
    @_makeShapeMesh(Param.mask.shapeNum.value)

    # size = Math.sqrt(movW * movW + movH * movH)
    # for val,i in @_mask.children
    #   if w > h
    #     sx = size / @_mask.children.length
    #     val.scale.set(sx, size, sx)
    #     val.position.x = i * sx + (sx * 0.5) - (@_mask.children.length * sx * 0.5)
    #     val.position.y = 0
    #   else
    #     sy = size / @_mask.children.length
    #     val.scale.set(size, sy, sy)
    #     val.position.x = 0
    #     val.position.y = i * sy + (sy * 0.5) - (@_mask.children.length * sy * 0.5)






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


    w = window.innerWidth
    h = window.innerHeight
    movW = movH = Math.max(w, h)
    size = Math.sqrt(movW * movW + movH * movH)

    @_mask.rotation.z = Util.radian(45)

    i = 0
    num = ~~(Param.mask.shapeNum.value)
    while i < num

      mesh = new THREE.Mesh(
        new THREE.PlaneBufferGeometry(1, 1),
        new THREE.MeshBasicMaterial({
          color:0x000000
        })
      )

      @_shapes.push(mesh)
      @_mask.add(mesh)

      sy = size / num
      mesh.scale.set(size, sy, sy)
      mesh.position.x = 0
      mesh.position.y = i * sy + (sy * 0.5) - (num * sy * 0.5)

      i++

    # max = Math.max(window.innerWidth, window.innerHeight) * 0.5
    #
    # i = 0
    # num = ~~(num)
    # while i <= num
    #
    #   radius = max - (i * (max / num))
    #   shape = new THREE.Mesh(
    #     new THREE.CircleBufferGeometry(radius, 16),
    #     new THREE.MeshBasicMaterial({
    #       color:0x000000
    #       # blending:THREE.MultiplyBlending
    #     })
    #   )
    #   @_shapes.push(shape)
    #   @_mask.add(shape)
    #
    #
    #
    #   i++


    # @_mask.children.reverse()

















module.exports = MovieCanvas
