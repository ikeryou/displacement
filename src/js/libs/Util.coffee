

# ---------------------------------------------------
# 便利関数クラス
# ---------------------------------------------------
class Util

  constructor: ->


  # ランダムな数(float)
  # -----------------------------------
  # @min : 最小値(float)
  # @max : 最大値(float)
  # return : min(含む)からmax(含む)までのランダムな数(float)
  # -----------------------------------
  random: (min, max) =>

    return Math.random() * (max - min) + min



  # ランダムな数(int)
  # -----------------------------------
  # @min : 最小値(int)
  # @max : 最大値(int)
  # return : min(含む)からmax(含む)までのランダムな数(int)
  # -----------------------------------
  randomInt: (min, max) =>

    return Math.floor(Math.random() * (max - min + 1)) + min



  # 1/@rangeの確率でtrueを取得
  # -----------------------------------
  # @range : 2以上の分母(int)
  # return : true or false(boolean)
  # -----------------------------------
  hit: (range) =>

    if range < 2 || !range? then range = 2
    return (@randomInt(0, range - 1) == 0)



  # 複数指定した範囲の中からランダムな数を取得(float)
  # -----------------------------------
  # @list : [{min:最小値(foat), max:最大値(float)},...]
  # return : min(含む)からmax(含む)までのランダムな数(float)
  # -----------------------------------
  randomList: (list) =>

    area = @randomArr(list)
    return @random(area.min, area.max)



  # 複数指定した範囲の中からランダムな数を取得(int)
  # -----------------------------------
  # @list : [{min:最小値(int), max:最大値(int)},...]
  # return : min(含む)からmax(含む)までのランダムな数(int)
  # -----------------------------------
  randomListInt: (list) =>

    area = @randomArr(list)
    return @randomInt(area.min, area.max)



  # 配列内の値をランダムに取得
  # -----------------------------------
  randomArr: (arr) =>

    return arr[@randomInt(0, arr.length - 1)]



  # パラメータ数
  # -----------------------------------
  paramNum: (obj) =>

    num = 0
    for val,key of obj
      num++

    return num



  # -指定値から指定値までのランダムな数(float)
  # -----------------------------------
  # @val : 指定値(float)
  # return : -@valから@valまでのランダムな数(float)
  # -----------------------------------
  range: (val) =>

    return @random(-val, val)



  # -指定値から指定値までのランダムな数(int)
  # -----------------------------------
  # @val : 指定値(int)
  # return : -@valから@valまでのランダムな数(int)
  # -----------------------------------
  rangeInt: (val) =>

    return @randomInt(-val, val)



  # 値を範囲内におさめる
  # -----------------------------------
  # @val : 値
  # @min : 最小値
  # @max : 最大値
  # -----------------------------------
  clamp: (val, min, max) =>

    return Math.min(max, Math.max(val, min))



  # 値のマッピング
  # -----------------------------------
  # @num     : マッピングする値
  # @toMin   : 変換後の最小値
  # @toMax   : 変換後の最大値
  # @fromMin : 変換前の最小値
  # @fromMax : 変換前の最大値
  # -----------------------------------
  map: (num, toMin, toMax, fromMin, fromMax) =>

    if num <= fromMin then return toMin
    if num >= fromMax then return toMax

    p = (toMax - toMin) / (fromMax - fromMin)
    return ((num - fromMin) * p) + toMin



  # ラジアンに変換
  # -----------------------------------
  radian: (degree) =>

    return degree * Math.PI / 180



  # 角度に変換
  # -----------------------------------
  degree: (radian) =>

    return radian / Math.PI / 180



  # 配列をランダムに並べ替え
  # -----------------------------------
  shuffle: (arr) =>

    i = arr.length
    while --i
      j = Math.floor(Math.random() * (i + 1))
      if i == j then continue
      k = arr[i]
      arr[i] = arr[j]
      arr[j] = k



  # nullを削除した配列を返す
  # -----------------------------------
  sliceNull: (arr) =>

    newArr = []
    for val,i in arr
      if val != null
        newArr.push(val)

    return newArr



  # 文字列の全置換
  # -----------------------------------
  replaceAll: (val, org, dest) =>

    return val.split(org).join(dest)



  # 配列内のパラメータを比較してソート
  # -----------------------------------
  # @arr  : 配列
  # @para : パラメーター名
  # @desc : 降順かどうか(boolean) デフォルトは昇順
  # -----------------------------------
  sort: (arr, para, desc) =>

    if !desc? then desc = false

    if desc
      arr.sort((a, b) =>
        return b[para] - a[para]
      )
    else
      arr.sort((a, b) =>
        return a[para] - b[para]
      )



  # ２点間の距離
  # -----------------------------------
  distance: (x1, y1, x2, y2) =>

    dx = x1 - x2
    dy = y1 - y2

    return Math.sqrt(dx * dx + dy * dy)



  # 数値を文字列に変換
  # -----------------------------------
  # @num  : 数値
  # @keta : 桁数
  # -----------------------------------
  numStr: (num, keta) =>

    str = String(num)

    if str.length >= keta
      return str

    len = keta - str.length
    i = 0
    while i < len
      str = '0' + str
      i++

    return str



  # edgeかどうか
  # -----------------------------------
  isEdge: =>

    ua = window.navigator.userAgent.toLowerCase()
    return ua.indexOf('edge') != -1


  # IEかどうか
  # -----------------------------------
  isIE: =>

    ua = window.navigator.userAgent.toLowerCase()
    return (ua.indexOf('msie') != -1 || ua.indexOf('trident/7') != -1　|| ua.indexOf('edge') != -1)



  # WINかどうか
  # -----------------------------------
  isWin: =>

    return (window.navigator.platform.indexOf('Win') != -1)



  # googleChromeかどうか
  # -----------------------------------
  isChrome: =>

    return (window.navigator.userAgent.toLowerCase().indexOf('chrome') != -1)



  # FireFoxかどうか
  # -----------------------------------
  isFF: =>

    return (window.navigator.userAgent.toLowerCase().indexOf('firefox') != -1)



  # Safariかどうか
  # -----------------------------------
  isSafari: =>

    return (window.navigator.userAgent.toLowerCase().indexOf('safari') != -1)



  # rgbからHEXカラー取得
  # -----------------------------------
  # @r : 0~255
  # @g : 0~255
  # @b : 0~255
  # return : ex '#FFFFFF'
  # -----------------------------------
  getHexColor: (r,g,b) =>

    str = (r << 16 | g << 8 | b).toString(16)
    return '#' + new Array(7 - str.length).join('0') + str



  # -----------------------------------
  # webGL使えるか
  # -----------------------------------
  useWebGL: =>

    try

      c = document.createElement('canvas')
      w = c.getContext('webgl') || c.getContext('experimental-webgl')
      return !!(window.WebGLRenderingContext && w && w.getShaderPrecisionFormat)

    catch e

      return false













module.exports = new Util()
