Conf   = require('./Conf')
Stats  = require('stats-js')
Update = require('../libs/Update')


class Profiler

  constructor: ->

    if Conf.FLG.STATS

      @_stats = new Stats()
      @_stats.domElement.style.position = 'fixed'
      @_stats.domElement.style.left     = '0px'
      @_stats.domElement.style.top      = '0px'
      @_stats.domElement.style.zIndex   = '99999'
      document.body.appendChild(@_stats.domElement)

      Update.add(=>
        @_stats.update()
      )






module.exports = new Profiler()
