Resize  = require('../libs/Resize')
Size    = require('../libs/obj/Size')
Type    = require('./Type')
Conf    = require('./Conf')

# 共通関数
class Func

  constructor: ->



  # ------------------------------------
  # 画面サイズ
  # ------------------------------------
  winSize: =>

    if isMobile.any
      w = window.innerWidth
      h = screen.height || window.innerHeight
    else
      w = window.innerWidth
      h = window.innerHeight

    return new Size(w, h)



  # ------------------------------------
  # レティナのあの値
  # ------------------------------------
  ratio: =>

    return window.devicePixelRatio || 1



  # ------------------------------------
  # スクリーンタイプ取得
  # ------------------------------------
  screen: =>

    if Resize.sw() <= Conf.BREAKPOINT
      return Type.SCREEN.XS
    else
      return Type.SCREEN.LG



  # ------------------------------------
  # スクリーンタイプ LG
  # ------------------------------------
  isLG: =>

    return @screen() == Type.SCREEN.LG



  # ------------------------------------
  # スクリーンタイプ XS
  # ------------------------------------
  isXS: =>

    return @screen() == Type.SCREEN.XS



  # ------------------------------------
  # コクのあるサイン 1
  # ------------------------------------
  sin1: (radian) =>

    return Math.sin(radian) + Math.sin(2 * radian)



  # ------------------------------------
  # コクのあるサイン 2
  # ------------------------------------
  sin2: (radian) =>

    return (
      Math.sin(radian) +
      Math.sin(2.2 * radian + 5.52) +
      Math.sin(2.9 * radian + 0.93) +
      Math.sin(4.6 * radian + 8.94)
    ) / 4



  # ------------------------------------
  # TweenMaxのラッパー関数
  # ------------------------------------
  a: (target, param, duration, delay, easing, callback) =>

    TweenMax.killTweensOf(target)

    from = {}
    to = {}


    for key,val of param
      if val[0]?
        from[key] = val[0]
        to[key]   = val[1]
      else
        to[key] = val
      # if !target[key]?
      #   target[key] = val[0]

    TweenMax.set(target, from)

    if easing?
      to.ease = easing

    if delay?
      to.delay = delay

    if callback?
      to.onComplete = callback

    to.force3D = true

    TweenMax.to(target, duration, to)



  # ------------------------------------
  # フェードイン
  # ------------------------------------
  fadein: (target, duration, delay, callback) =>

    @a(target, {
      opacity:[0, 1]
    }, duration, delay, Expo.easeOut, callback)



  # ------------------------------------
  # フェードアウト
  # ------------------------------------
  fadeout: (target, duration, delay, callback) =>

    @a(target, {
      opacity:[1, 0]
    }, duration, delay, Expo.easeOut, callback)




  # ------------------------------------
  # 画面全体の操作ON/OFF
  # 引数なしの場合、状態が boolean で返る
  # ------------------------------------
  clickable: (bool) =>

    c = 'noPointer'
    body = $('body')

    if !bool?
      return !body.hasClass(c)
    else
      if bool
        body.removeClass(c)
      else
        body.addClass(c)



  # ------------------------------------
  # レスポンシブ画像の出し分け
  # ------------------------------------
  resImg: =>

    $('.resImg').each((key, el) =>

      el = $(el)
      s = @screen()

      # src
      src = el.attr('data-img')
      if @isXS()
        src = src.replace('{t}', '_xs')
      else
        src = src.replace('{t}', '_lg')
      if el.attr('src') != src
        el.attr('src', src)

      # サイズ
      w = el.attr('data-width')
      if w? && w != ''
        el.attr('width', w.split(',')[s])
      h = el.attr('data-height')
      if h? && h != ''
        el.attr('height', h.split(',')[s])

    )








module.exports = new Func()
