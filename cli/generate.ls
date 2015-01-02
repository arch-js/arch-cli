module.exports = ->
  it
    .command 'generate <type> [args...]'
    .description 'Generate something in an existing Reflex app.'
    .alias 'g'
    .action (type, args) ->
      console.log 'Generating a %s, arguments: %s', type, (args |> join ', ')
    .on '--help', ->
      console.log 'TODO: This help text...'