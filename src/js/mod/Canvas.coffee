MyDisplay = require('../core/MyDisplay')
Param     = require('../core/Param')
Func      = require('../core/Func')
Conf      = require('../core/Conf')
Util      = require('../libs/Util')


class Canvas extends MyDisplay


  constructor: (opt) ->

    super({
      update:true
      resize:true
      el:opt.el
    })

    @camera = []
    @renderer
    @mainScene



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    @_makeRenderer()
    @_makeMainScene()



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    super()

    @renderer.autoClear = true
    @renderer.render(@mainScene, @camera)



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    # 画面サイズ
    w = window.innerWidth
    h = window.innerHeight

    @camera.aspect = w / h
    @camera.updateProjectionMatrix()

    @renderer.setPixelRatio(window.devicePixelRatio || 1)
    @renderer.setSize(w, h, true)
    @renderer.clear()



  # -----------------------------------------------
  # カメラ作成
  # -----------------------------------------------
  _makeCamera: (param) =>

    param = param || {}

    if param.isOrthographic
      return new THREE.OrthographicCamera()
    else
      return new THREE.PerspectiveCamera(45, 1, 0.1, 50000)



  # -----------------------------------------------
  # Perspectiveカメラ設定
  # -----------------------------------------------
  _updatePerspectiveCamera: (camera, w, h) =>

    camera.aspect = w / h
    camera.updateProjectionMatrix()
    camera.position.z = h / Math.tan(camera.fov * Math.PI / 360) / 2



  # -----------------------------------------------
  # Orthographicカメラ設定
  # -----------------------------------------------
  _updateOrthographicCamera: (camera, w, h) =>

    w = w || 10
    h = h || 10

    camera.left = -w * 0.5
    camera.right = w * 0.5
    camera.top = h * 0.5
    camera.bottom = -h * 0.5
    camera.near = 0.1
    camera.far = 10000
    camera.zoom = 1
    camera.updateProjectionMatrix()
    camera.position.set(0, 0, 1)
    camera.lookAt(new THREE.Vector3(0, 0, 0))



  # -----------------------------------------------
  # レンダラー作成
  # -----------------------------------------------
  _makeRenderer: =>

    @renderer = new THREE.WebGLRenderer({
      # canvas             : document.getElementById(@el().attr('id'))
      canvas             : @el().get(0)
      alpha              : true
      antialias          : true
      stencil            : false
      depth              : false
      premultipliedAlpha : true
    })
    @renderer.autoClear = true
    @renderer.setClearColor(0xece9eb)

    if Util.isSafari() || Util.isFF()
      @renderer.context.getShaderInfoLog = =>
        return ''



  # -----------------------------------------------
  # メインシーン作成
  # -----------------------------------------------
  _makeMainScene: =>

    @mainScene = new THREE.Scene()










module.exports = Canvas
