
# 遅延実行関数クラス
class Delay

  constructor: ->
  
    @_registFunc = []
    
    @_init()
  
  
  
  _init: ->
    
    t = window.requestAnimationFrame(@_update)
  
  
  
  # -----------------------------------------------
  # 関数を登録
  # @func  : 関数
  # @delay : このフレーム後に実行
  # -----------------------------------------------
  add: (func, delay) =>
    
    @_slice()
    
    @_registFunc.push({
      f:   func
      d:   Number(delay)
      flg: true
    })
  
  
  
  # -----------------------------------------------
  # 関数を削除
  # @func : 関数
  # -----------------------------------------------
  remove: (func) =>
  
    arr = []
    for val,i in @_registFunc
      if val? && val.f != func
        arr.push(val)
    @_registFunc = arr
  
  
  
  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    for val,i in @_registFunc
      if val? && val.flg && --val.d <= 0
        val.f()
        val.flg = false
    
    window.requestAnimationFrame(@_update)
  
  
  
  # -----------------------------------------------
  # 実行済み関数の削除
  # -----------------------------------------------
  _slice: =>
    
    for val,i in @_registFunc
      if val? && !val.flg
        @_registFunc[i] = null
    
    newArr = []
    for val,i in @_registFunc
      if val? then newArr.push(val)
    
    @_registFunc = newArr













module.exports = new Delay()