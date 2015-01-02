module.exports = ->
  it
    .command 'serve'
    .description 'Start your app\'s server'
    .alias 's'
    .option '-p, --port <port>'
    .action (options) ->
      console.log 'Starting server on port', (options.port or process.env.PORT or 3000)
    .on '--help', ->
      console.log 'TODO: This help text'