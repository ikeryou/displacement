Func  = require('./Func')
Param = require('./Param')


# 画面のスクロール
class Scroller


  constructor: ->

    @_el = $('html,body')
    # @_el = $('body')



  # -----------------------------------------------
  # スクロール開始
  # -----------------------------------------------
  start: (tg, duration, delay, callback) =>

    duration = duration || 1
    delay = delay || 0

    Func.a(@_el, {
      scrollTop:[Param.scroll, tg]
    }, duration, delay, Expo.easeInOut, callback)



  # -----------------------------------------------
  # すぐにスクロール位置を変更
  # -----------------------------------------------
  fast: (tg) =>

    @start(tg, 0)







module.exports = new Scroller()
