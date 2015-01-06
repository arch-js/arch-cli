require! {
  fs
  path
  child_process
  'is-running'
  'node-watch': watch
}

server = null

module.exports = ->
  it
    .command 'serve'
    .description 'Start your app\'s server'
    .alias 's'
    .option '-d, --daemonise', 'Run as a background process'
    .option '-i, --pidfile <pidfile>', 'Specify a pidfile to use.'
    .option '-l, --log <file>', 'Specify a file to log to.'
    .option '-p, --port <port>', 'Specify a server port (sets the REFLEX_PORT environment variable)'
    .option '-s, --standalone', "Run in standalone mode, without Reflex's gulp-based server task."
    .option '-w, --watch', 'Watch for changes and restart server on change.'
    .action serve
    .on '--help', ->
      console.log 'TODO: This help text'

serve = (opts) ->
  pidfile = opts.pidfile or (path.resolve './server.pid')
  fs.exists pidfile, (exists) ->
    if exists
      pid = fs.read-file-sync pidfile, encoding: 'utf8'
      if is-running +pid
        console.log "Server already running (pid #pid)"
      else
        fs.unlink pidfile, (err) ->
          throw err if err
          init opts
    else
      init opts

init = (opts) ->
  start-server opts
  if opts.watch
    watch-server opts

start-server = (opts) ->
  s-opts =
    env: process.env import do
      REFLEX_PORT: opts.port or process.env.REFLEX_PORT or undefined
    detached: opts.daemonise

  if opts.standalone
    server := child_process.spawn 'npm', ['start'], s-opts
  else
    server := child_process.exec 'node server.js', s-opts

  [server.stdout, server.stderr] |> each ->
    it.set-encoding 'utf8'
    it.on 'data' !->
      console.log it
      if opts.log
        fs.append-file opts.log, "#it\n", (err) ->
          console.error err if err

  fs.write-file (opts.pidfile or (path.resolve './server.pid')), server.pid, (err) -> throw err if err

stop-server = (opts) ->
  server.kill!

restart-server = (opts) ->
  server.on 'exit', ->
    start-server opts
  stop-server opts

watch-server = (opts) ->
  watch ['lib', 'app'], (file) ->
    switch (file |> split \. |> last)
      | \ls => restart-server opts
      | \js => restart-server opts