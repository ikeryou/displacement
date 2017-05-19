

# ------------------------------------
# jQuery要素のラッパークラス
# ------------------------------------
class Display

  # ------------------------------------
  # コンストラクタ
  # ------------------------------------
  # @opt.el   : 管理するjQuery要素 ない場合divを新規につくる
  # @opt.tag  : 初期タグ
  # @opt.attr : 初期要素
  # ------------------------------------
  constructor: (opt) ->

    @_opt = opt || {}
    if !@_opt.tag? then @_opt.tag = 'div'

    # 反映中のCSSパラメータ
    @_css = {}
    @_tmpCss = {}

    # 子要素
    @_children = []

    # 親要素
    @_parent

    @_isDisplayNone = false



  # -----------------------------------
  # 初期化
  # -----------------------------------
  init: =>

    # なかったらdivで作る
    if !@_opt.el?
      id = @_createId()
      $('body').append('<' + @_opt.tag + ' id="' + id + '"></' + @_opt.tag + '>')
      @_opt.el = $('#' + id)

    # 属性あればつける
    if @_opt.attr?
      @_opt.el.attr(@_opt.attr)



  # -----------------------------------
  # 破棄
  # -----------------------------------
  dispose: =>

    if @_children?
      for val,i in @_children
        if val?
          val.dispose()
      @_children = null

    if @_el?
      @_el.off()
      @_el.remove()
      @_el = null

    @_opt    = null
    @_css    = null
    @_tmpCss = null
    @_parent = null



  # -----------------------------------
  # 完全に消す
  # -----------------------------------
  setDisplayNone: (flg) =>

    if @_isDisplayNone != flg
      if flg
        @el().css('display', 'none')
      else
        @el().css('display', '')
      @_isDisplayNone = flg



  # -----------------------------------
  # ID発行
  # -----------------------------------
  _createId: =>

    if !window.MY_DISPLAY_ID?
      window.MY_DISPLAY_ID = 0

    return 'display' + String(window.MY_DISPLAY_ID++)



  # -----------------------------------
  # jQuery要素
  # -----------------------------------
  el: =>

    return @_opt.el



  # -----------------------------------
  # ID あれば
  # -----------------------------------
  id: =>

    return @el().attr('id')



  # -----------------------------------
  # classつける
  # -----------------------------------
  addClass: (c) =>

    @el().addClass(c)

    return @



  # -----------------------------------
  # class消す
  # -----------------------------------
  removeClass: (c) =>

    @el().removeClass(c)

    return @



  # -----------------------------------
  # 親要素
  # -----------------------------------
  parent: (disp) =>

    if disp?
      @_parent = disp
    else
      return @_parent



  # -----------------------------------
  # 子要素
  # -----------------------------------
  children: (disp) =>

    if disp? && !@hasChild(disp)
      @_children.push(disp)
    else
      return @_children



  # -----------------------------------
  # 最初の子要素
  # -----------------------------------
  firstChild: =>

    return @_children[0]



  # -----------------------------------
  # 最後の子要素
  # -----------------------------------
  lastChild: =>

    return @_children[@_children.length - 1]



  # -----------------------------------
  # 子要素として存在してるかチェック
  # -----------------------------------
  hasChild: (disp) =>

    for val,i in @_children
      if val == disp
        return true

    return false



  # -----------------------------------
  # 子要素として追加 最前面
  # -----------------------------------
  add: (disp) =>

    disp.el().appendTo(@el())

    @children(disp)
    disp.parent(@)

    return disp



  # -----------------------------------
  # 子要素として追加 最背面
  # -----------------------------------
  unshift: (disp) =>

    disp.el().prependTo(@el())

    @children(disp)
    disp.parent(@)

    return disp



  # -----------------------------------
  # 幅の設定、取得
  # -----------------------------------
  width: (width) =>

    if width?
      @_css.width = width
      return @
    else
      if @_css.width?
        return @_css.width
      else
        return @el().width()



  # -----------------------------------
  # 高さの設定、取得
  # -----------------------------------
  height: (height) =>

    if height?
      @_css.height = height
      return @
    else
      if @_css.height?
        return @_css.height
      else
        return @el().height()



  # -----------------------------------
  # 幅 半分
  # -----------------------------------
  width2: (isFloor) =>

    if isFloor
      return ~~(@width() * 0.5)
    else
      return @width() * 0.5



  # -----------------------------------
  # 高さ 半分
  # -----------------------------------
  height2: (isFloor) =>

    if isFloor
      return ~~(@height() * 0.5)
    else
      return @height() * 0.5



  # -----------------------------------
  # サイズ設定
  # -----------------------------------
  size: (width, height) =>

    @_css.width  = width
    @_css.height = height

    return @



  # -----------------------------------
  # サイズのコピー
  # -----------------------------------
  copySize: (disp) =>

    @_css.width  = disp.width()
    @_css.height = disp.height()

    return @



  # -----------------------------------
  # css position
  # -----------------------------------
  pos: (val) =>

    if !val? then val = 'absolute'
    @_css.position = val

    return @



  # -----------------------------------
  # 位置 top,left
  # -----------------------------------
  tl: (top, left) =>

    @_css.top  = top
    @_css.left = left

    return @



  # -----------------------------------
  # 位置 bottom,right
  # -----------------------------------
  br: (bottom, right) =>

    @_css.bottom = bottom
    @_css.right  = right

    return @



  # -----------------------------------
  # CSSプロパティの設定、取得
  # -----------------------------------
  cssProp: (name, val) =>

    if !val?
      return @_css[name]
    else
      @_css[name] = val
      return @



  # -----------------------------------
  # 位置 top
  # -----------------------------------
  top: (val) =>

    return @cssProp('top', val)



  # -----------------------------------
  # 位置 left
  # -----------------------------------
  left: (val) =>

    return @cssProp('left', val)



  # -----------------------------------
  # 位置 bottom
  # -----------------------------------
  bottom: (val) =>

    return @cssProp('bottom', val)



  # -----------------------------------
  # 位置 right
  # -----------------------------------
  right: (val) =>

    return @cssProp('right', val)



  # -----------------------------------
  # 背景色の設定、取得
  # -----------------------------------
  bgColor: (val) =>

    return @cssProp('backgroundColor', val)



  # -----------------------------------
  # 色の設定、取得
  # -----------------------------------
  color: (val) =>

    return @cssProp('color', val)



  # -----------------------------------
  # 透明度の取得、設定
  # -----------------------------------
  opacity: (val) =>

    return @cssProp('opacity', val)



  # -----------------------------------
  # マスク設定 css overflow
  # -----------------------------------
  mask: (bool) =>

    @_css.overflow = if bool then 'hidden' else 'visible'
    return @



  # -----------------------------------
  # renderメソッド内で変更したいCSS
  # -----------------------------------
  css: =>

    return @_css



  # -----------------------------------
  # DOMに反映
  # -----------------------------------
  render: =>

    if @_isChange()

      #console.log('renbder')

      #TweenMax.killTweensOf(@el())
      #console.log(@_css)
      TweenMax.set(@el(), {css:@_css})

      # 値をコピー
      for key,value of @_css
        @_tmpCss[key] = value

    return @



  # -----------------------------------
  # 変更されてるかチェック
  # -----------------------------------
  _isChange: =>

    for key,value of @_css
      if value != @_tmpCss[key]
        return true

    return false











module.exports = Display
