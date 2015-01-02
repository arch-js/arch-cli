module.exports = ->
  it
    .command 'init <appname>'
    .description 'Initialise a Reflex application in the current working directory.'
    .alias 'i'
    .option '-a, --author <author>'
    .action (appname, options) ->
      console.log 'App Name: %s, Author: %s', appname, options.author
    .on '--help', ->
      console.log 'TODO: This help text'