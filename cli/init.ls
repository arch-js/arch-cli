require! '../lib/init.ls'

module.exports = ->
  it
    .command 'init [appdir] [appname]'
    .description 'Initialise a Reflex application in the current working directory.'
    .alias 'i'
    .option '-a, --author <author>'
    .action init
    .on '--help', ->
      console.log 'TODO: This help text'