require! <[
  fs
  path
  child_process
  is-running
]>

async-log = ->
  logfile = fs.open-sync it, 'a'
  ['ignore', logfile, logfile]

start-server = (opts) ->
  s-opts =
    env: process.env import do
      REFLEX_PORT: opts.port or process.env.REFLEX_PORT or undefined
    detached: opts.daemonise
    stdio: if opts.daemonise => (if opts.log => async-log opts.log else 'ignore') else 'pipe'

  if opts.standalone
    server = child_process.spawn 'npm', ['start'], s-opts
  else
    # TODO: Expose a programmatic API in the reflex server to allow starting it without child_process
    server = child_process.spawn (path.resolve './node_modules/.bin/gulp'), ['serve'], s-opts

  if opts.daemonise
    fs.write-file (opts.pidfile or (path.resolve './tmp/server.pid')), server.pid, (err) ->
      if err
        console.error err
      else
        server.unref!
        console.log 'Server started. PID:', server.pid
  else
    [server.stdout, server.stderr] |> each ->
      it.set-encoding 'utf8'
      it.on 'data' !->
        console.log it
        if opts.log
          fs.append-file opts.log, "#it\n", console.error

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
    .action (opts) ->
      pidfile = opts.pidfile or (path.resolve './tmp/server.pid')
      fs.exists pidfile, (exists) ->
        if exists
          pid = fs.read-file-sync pidfile, encoding: 'utf8'
          if is-running +pid
            console.log "Server already running (PID: #pid)"
          else
            fs.unlink-sync pidfile
            start-server opts
        else
          start-server opts

    .on '--help', ->
      console.log 'TODO: This help text'