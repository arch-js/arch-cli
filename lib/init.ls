require! {
  'yeoman-environment': yo
  path
  './build.ls'
}

module.exports = init = (name, opts) ->
  env = yo.create-env!
  env.register 'generator-reflex'
  env.run 'reflex', do
    dir: opts.dir
    name: (name |> join ' ')