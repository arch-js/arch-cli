module.exports = ->
  it
    .command 'install <module>'
    .description 'Install a Reflex module.'
    .alias 'in'
    .action (module) ->
      console.log 'Installing %s', module
    .on '--help', ->
      console.log 'TODO: This help text...'