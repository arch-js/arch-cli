require! {
  'yeoman-environment': yo
}

module.exports = init = (appdir, appname, opts) ->
  env = yo.create-env!
  env.register 'generator-reflex'
  env.run 'reflex'