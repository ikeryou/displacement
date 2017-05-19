
'use strict'

const BrowserSyncPlugin = require('browser-sync-webpack-plugin')


module.exports = {
  entry: {
    top:'./src/js/core/Main.coffee'
  },
  output: {
    path: './docs/assets/js',
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee'
      },
      {
        test: /\.json$/,
        loader: 'json'
      },
      {
        test: /\.(vert|frag|glsl)$/,
        loaders: ['raw-loader', 'glslify-loader']
      }
    ]
  },
  resolve: {
    extensions: ['', '.coffee', '.js']
  },
  plugins: [
    new BrowserSyncPlugin({
      host: 'localhost',
      port: 3000,
      server: {
        baseDir: ['./docs']
      },
      open: false,
      injectChanges: true,
      files: [
        './docs/**/*.js',
        './docs/**/*.css',
        './docs/**/*.html'
      ],
      ghostMode: false
    })
  ]
}
