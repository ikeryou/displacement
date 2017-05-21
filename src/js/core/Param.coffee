dat  = require('dat-gui')
Conf = require('./Conf')


# ---------------------------------------------------
# 可変パラメータ
# ---------------------------------------------------
class Param

  constructor: ->

    @_gui

    #
    @mask = {
      shapeNum:{value:20, min:2, max:50}
      strength:{value:90, min:0, max:100, flg:true}
      noise:{value:200, min:0, max:200, flg:true}
      rotation:{value:45, min:-180, max:180, flg:true}
      offsetX:{value:100, min:0, max:100, flg:true}
      offsetY:{value:100, min:0, max:100, flg:true}
      kake:{value:400, min:0, max:1000}
      showMask:{value:false}
      showDiffuse0:{value:false}
      showDiffuse1:{value:false}
      moveRGB:{value:true, flg:true}
    }

    @listen = {
      r:{value:0, min:0, max:1}
    }


    @_init()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>

    if !Conf.FLG.PARAM
      return

    @_gui = new dat.GUI()
    @_addGui(@mask)
    #@_addGuiListen(@listen)

    $('.dg').css('zIndex', 99999999)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _addGui: (obj) =>

    for key,val of obj
      if !val.flg?
        if key.indexOf('Color') > 0
          g = @_gui.addColor(val, 'value').name(key)
        else
          if val.list?
            g = @_gui.add(val, 'value', val.list).name(key)
          else
            g = @_gui.add(val, 'value', val.min, val.max).name(key)
        val.gui = g



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _addGuiListen: (obj) =>

    for key,val of obj
      @_gui.add(val, 'value').name(key).listen()









module.exports = new Param()
