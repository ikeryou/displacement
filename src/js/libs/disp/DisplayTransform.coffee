Display = require('./Display')

# ---------------------------------------------------
# jQuery要素のラッパークラス transformプロパティを使用
# ---------------------------------------------------
class DisplayTransform extends Display

  constructor: (opt) ->

    super(opt)

    @_transform = {}
    @_tmpTransform = {}



  # -----------------------------------
  # 初期化
  # -----------------------------------
  init: =>

    super()
    @reset()



  # -----------------------------------
  # 破棄
  # -----------------------------------
  dispose: =>

    @_tmpTransform = null
    @_transform    = null

    super()



  # -----------------------------------
  # transformの初期化
  # -----------------------------------
  reset: =>

    @_transform = {
      translateX:0
      translateY:0
      translateZ:0
      scaleX:1
      scaleY:1
      scaleZ:1
      rotateX:0
      rotateY:0
      rotateZ:0
    }

    for key,value of @_transform
      @_tmpTransform[key] = value

    @el().css(@_getVendorCss('transform', 'none'))



  # -----------------------------------
  # Transformプロパティの設定、取得
  # -----------------------------------
  transformProp: (name, val) =>

    if !val?
      return @_transform[name]
    else
      @_transform[name] = val
      return @



  # -----------------------------------
  # 移動 X
  # -----------------------------------
  translateX: (val) =>

    return @transformProp('translateX', val)



  # -----------------------------------
  # 移動 Y
  # -----------------------------------
  translateY: (val) =>

    return @transformProp('translateY', val)



  # -----------------------------------
  # 移動 Z
  # -----------------------------------
  translateZ: (val) =>

    return @transformProp('translateZ', val)



  # -----------------------------------
  # スケール 2D まとめて
  # -----------------------------------
  scale2: (val) =>

    @scaleX(val)
    @scaleY(val)

    return @



  # -----------------------------------
  # スケール X
  # -----------------------------------
  scaleX: (val) =>

    return @transformProp('scaleX', val)



  # -----------------------------------
  # スケール Y
  # -----------------------------------
  scaleY: (val) =>

    return @transformProp('scaleY', val)



  # -----------------------------------
  # スケール Z
  # -----------------------------------
  scaleZ: (val) =>

    return @transformProp('scaleZ', val)



  # -----------------------------------
  # 回転 2D
  # -----------------------------------
  rotate2: (degree) =>

    return @rotateZ(degree)



  # -----------------------------------
  # 回転 X
  # -----------------------------------
  rotateX: (degree) =>

    return @transformProp('rotateX', degree)



  # -----------------------------------
  # 回転 Y
  # -----------------------------------
  rotateY: (degree) =>

    return @transformProp('rotateY', degree)



  # -----------------------------------
  # 回転 Z
  # -----------------------------------
  rotateZ: (degree) =>

    return @transformProp('rotateZ', degree)



  # -----------------------------------
  # DOMに反映
  # -----------------------------------
  render: =>

    super()

    if @_isChangeTransform()

      val = ''
      val += @_getTranslateVal()
      val += ' '
      val += @_getRotateVal()
      val += ' '
      val += @_getScaleVal()

      @el().css(@_getVendorCss('transform', val))

      # 値をコピー
      for key,value of @_transform
        @_tmpTransform[key] = value



  # -----------------------------------
  # transformの値が変更されてるか
  # -----------------------------------
  _isChangeTransform: =>

    for key,value of @_transform
      if value != @_tmpTransform[key]
        return true

    return false



  # -----------------------------------
  # 基準点
  # -----------------------------------
  pivot: (val) =>

    val = val || '50% 50%'
    @el().css(@_getVendorCss('transform-origin', val))

    return @



  # -----------------------------------
  # 遠近
  # -----------------------------------
  perspective: (val) =>

    val = val || 250

    @el()
      .css(@_getVendorCss('transform-style', 'preserve-3d'))
      .css(@_getVendorCss('perspective', val))

    return @



  # -----------------------------------
  # ベンダープレフィックス付きのCSS
  # -----------------------------------
  _getVendorCss: (prop, val) =>

    res = {}
    res["-webkit-" + prop] = val
    res["-o-" + prop]      = val
    res["-khtml-" + prop]  = val
    res["-ms-" + prop]     = val
    res[prop]              = val

    return res



  # -----------------------------------
  # translate3d値の作成
  # -----------------------------------
  _getTranslateVal: =>

    if @_transform.translateX != 0 || @_transform.translateY != 0 || @_transform.translateZ != 0

      val =
        'translate3d(' +
        @_transform.translateX + 'px,' +
        @_transform.translateY + 'px,' +
        @_transform.translateZ + 'px)'

    else

      val = ''

    return val



  # -----------------------------------
  # rotate値の作成
  # -----------------------------------
  _getRotateVal: =>

    if @_transform.rotateX != 0 || @_transform.rotateY != 0 || @_transform.rotateZ != 0

      val = ''
      val += 'rotate3d(1,0,0,' + @_transform.rotateX + 'deg)'
      val += ' '
      val += 'rotate3d(0,1,0,' + @_transform.rotateY + 'deg)'
      val += ' '
      val += 'rotate3d(0,0,1,' + @_transform.rotateZ + 'deg)'

    else

      val = ''

    return val



  # -----------------------------------
  # scale値の作成
  # -----------------------------------
  _getScaleVal: =>

    if @_transform.scaleX != 1 || @_transform.scaleY != 1 || @_transform.scaleZ != 1

      val =
        'scale3d(' +
        @_transform.scaleX + ',' +
        @_transform.scaleY + ',' +
        @_transform.scaleZ + ')'

    else

      val = ''

    return val





module.exports = DisplayTransform
