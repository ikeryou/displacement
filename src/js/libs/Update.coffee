

# 画面更新クラス
class Update


  constructor:->

    # 更新回数
    @_cnt = 0

    # 毎フレーム実行させる関数を保持
    @_updateList = []


    @_init()


  _init: ->

    t = window.requestAnimationFrame(@_update)



  # -----------------------------------------------
  # 更新回数
  # -----------------------------------------------
  cnt: =>

    return @_cnt



  # -----------------------------------------------
  # 実行したい関数を登録
  # @func : 関数
  # -----------------------------------------------
  add: (func) =>

    @_updateList.push(func)



  # -----------------------------------------------
  # 実行したい関数を削除
  # @func : 関数
  # -----------------------------------------------
  remove: (func) =>

    arr = []
    for val, i in @_updateList
      if val != func
        arr.push(val)
    @_updateList = arr



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    @_cnt++

    # 登録してる関数を実行
    for val,i in @_updateList
      if val? then val()

    window.requestAnimationFrame(@_update)








module.exports = new Update()
