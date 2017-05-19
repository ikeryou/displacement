Resize           = require('../libs/Resize')
Update           = require('../libs/Update')
Util             = require('../libs/Util')
Delay            = require('../libs/Delay')
DisplayTransform = require('../libs/disp/DisplayTransform')
Point            = require('../libs/obj/Point')
Size             = require('../libs/obj/Size')
Func             = require('./Func')
Conf             = require('./Conf')
Type             = require('./Type')


class MyDisplay extends DisplayTransform

  constructor: (opt) ->

    if !opt?
      opt = {}

    if !opt.resize?
      opt.resize = false

    if !opt.update?
      opt.update = false

    super(opt)

    # 更新回数
    @_cnt = 0

    @winSize = new Size()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    if @_opt.resize
      Resize.add(@_resize)

    if @_opt.update
      Update.add(@_update)



  # -----------------------------------------------
  # 破棄
  # -----------------------------------------------
  dispose: =>

    Resize.remove(@_resize)
    Update.remove(@_update)

    super()



  # -----------------------------------------------
  # 表示、非表示
  # -----------------------------------------------
  visible: (bool) =>

    if bool
      @el().removeClass('hide')
    else
      @el().addClass('hide')



  # ------------------------------------
  # PC
  # ------------------------------------
  isPC: =>

    return !isMobile.any



  # ------------------------------------
  # スマホ
  # ------------------------------------
  isSP: =>

    return isMobile.any



  # ------------------------------------
  # 値半分にする
  # ------------------------------------
  half: (val) =>

    return ~~(val * 0.5)



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    @_cnt++



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: (size) =>

    @winSize.set(window.innerWidth, window.innerHeight)



  # -----------------------------------------------
  # ステージ幅
  # -----------------------------------------------
  sw: =>

    return Resize.sw()



  # -----------------------------------------------
  # ステージ高さ
  # -----------------------------------------------
  sh: =>

    return Resize.sh()



  # -----------------------------------------------
  # ステージ幅 半分
  # -----------------------------------------------
  sw2: =>

    return ~~(Resize.sw() * 0.5)



  # -----------------------------------------------
  # ステージ高さ 半分
  # -----------------------------------------------
  sh2: =>

    return ~~(Resize.sh() * 0.5)



  # -----------------------------------------------
  # スクリーンタイプ でかいやつ
  # -----------------------------------------------
  isLG: =>

    return (window.innerWidth > Conf.BREAKPOINT)



  # -----------------------------------------------
  # スクリーンタイプ ちいさいやつ
  # -----------------------------------------------
  isXS: =>

    return (window.innerWidth <= Conf.BREAKPOINT)



  # -----------------------------------------------
  # %つける
  # -----------------------------------------------
  pct: (val) =>

    return (val * 100) + '%'



  # -----------------------------------------------
  # スクリーンタイプによって出し分け
  # -----------------------------------------------
  v: (xsVal, lgVal) =>

    if @isXS()
      return xsVal
    else
      return lgVal


















module.exports = MyDisplay
