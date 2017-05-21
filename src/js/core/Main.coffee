window.$                     = require('jquery')
window.requestAnimationFrame = require('raf')
window.THREE                 = require('three')
window.TweenMax              = require('TweenMax')
window.CustomEase            = require('CustomEase')
window.TimelineMax           = require('TimelineMax')
window.isMobile              = require('ismobilejs')


Profiler    = require('../core/Profiler')
MovieCanvas = require('../mod/MovieCanvas')


# エントリーポイント
class Main

  constructor: ->


  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    canvas = new MovieCanvas({
      el:$('.test')
    })
    canvas.init()





module.exports = Main


main = new Main()
main.init()
