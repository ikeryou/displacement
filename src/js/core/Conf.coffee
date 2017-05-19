
class Conf

  constructor: ->

    # 本番フラグ
    @RELEASE = false

    # フラグ関連
    @FLG = {
      PARAM:true
      STATS:true
    };

    # 本番フラグがtrueの場合、フラグ関連は全てfalseに
    if @RELEASE
      for key,val of @FLG
        @FLG[key] = false









module.exports = new Conf()
