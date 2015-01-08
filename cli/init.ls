require! {
  'yeoman-generator': yo
  'generator-reflex'
}

module.exports = ->
  it
    .command 'init [appname]'
    .description 'Initialise a Reflex application in the current working directory.'
    .alias 'i'
    .option '-a, --author <author>'
    .action (appname, opts) ->
      env = yo.create-env!
      env.register 'generator-reflex'
      env.run 'reflex'
    .on '--help', ->
      console.log 'TODO: This help text'