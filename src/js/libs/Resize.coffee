Util = require('./Util')

# リサイズクラス
class Resize


  constructor: ->

    # リサイズ時に実行させる関数を保持
    @_resizeList = []

    # サイズ
    @_size = {
      width:0
      height:0
    }
    @_oldSize = {
      width:0
      height:0
    }

    @_timer

    @_init()



  _init: =>

    window.addEventListener('resize', @_eResize)
    @_setStageSize()



  # -----------------------------------------------
  # 関数を登録
  # @func   : 関数 リサイズ時にウィンドウサイズを引数として渡す
  # @isCall : trueの場合この後すぐに実行される def=false
  # -----------------------------------------------
  add: (func, isCall) ->

    @_resizeList.push(func)

    if isCall? && isCall
      func(@_size)



  # -----------------------------------------------
  # 関数を削除
  # @func : 関数
  # -----------------------------------------------
  remove: (func) ->

    arr = []
    for val,i in @_resizeList
      if val != func
        arr.push(val)
    @_resizeList = arr



  # -----------------------------------------------
  # リサイズを外から実行
  # -----------------------------------------------
  refresh: =>

    @_eResize()



  # -----------------------------------------------
  # イベント リサイズ
  # -----------------------------------------------
  _eResize: (e) =>

    # ステージサイズの更新
    @_setStageSize()

    # 登録してある関数を実行
    if @_timer?
      clearInterval(@_timer)
      @_timer = null
    @_timer = setTimeout(@_call, 300)



  # -----------------------------------------------
  # 登録してある関数を実行
  # -----------------------------------------------
  _call: =>

    for val,i in @_resizeList
      val(@_size)



  # -----------------------------------------------
  # ステージサイズの更新
  # -----------------------------------------------
  _setStageSize: =>

    @_oldSize.width  = @_size.width
    @_oldSize.height = @_size.height

    @_size.width  = window.innerWidth
    @_size.height = window.innerHeight



  # -----------------------------------------------
  # ステージ幅
  # -----------------------------------------------
  sw: =>

    @_setStageSize()
    return @_size.width



  # -----------------------------------------------
  # ステージ高さ
  # -----------------------------------------------
  sh: =>

    @_setStageSize()
    return @_size.height



  # -----------------------------------------------
  # サイズ
  # -----------------------------------------------
  size: =>

    return @_size



  # -----------------------------------------------
  # 前のサイズ
  # -----------------------------------------------
  oldSize: =>

    return @_oldSize












module.exports = new Resize()
