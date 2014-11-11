require 'shelljs/make'
require! {
  \fs
  \os
  \http

  \gaze
  \stylus
  lsc: \LiveScript
  \htmls
  app-generator: './server'
  \open
}

IP = void
DIR = __dirname
for k,v of os.network-interfaces!
  for i in v
    if !IP and i.family == \IPv4 and i.address.match /^192.168/
      IP := i.address

if not test \-e \.public
  mkdir \.public

target.all = ->
  target.compile!

target.release = ->
  tmpl-path = './views/index.htmls'
  template = htmls cat tmpl-path
  thefile = template {-dev-mode, ip: ''}
  thefile.to './.public/index.html'

# compile jade templates to JS
templates = ->
  console.log "Compiling templates..."
  # templatizer __dirname + '/views', __dirname + '/src/vendor/templates.js'

# compile livescript files to JS
js = ->
  console.log "Compiling JavaScript..."
  cd DIR + "/src"
  code = lsc.compile (cat ls "*.ls"), {+bare}
  cd DIR + "/src/vendor"
  libs = cat ls "*.js"
  body = """
    (function(){
      #libs
      #code
      Init();
    })();
  """
  cd DIR
  body.to "./.public/xcom-namegen.js"


# compile stylus files to css
css = ->
  console.log "Compiling CSS..."
  path = './styles/main.styl'
  stylus (cat path)
    .set \filename path
    .render (err, out) ->
      out.to "./.public/xcom-namegen.css"

asset = (fpath) ->
  cp \-f fpath, fpath.replace 'assets' '.public/assets'

# compile all stuff
target.compile = ->
  templates!
  js!
  css!

# the real sauce
target.watch = ->

  socks = []

  # server IP address
  console.log "Server IP: #IP"

  refresh = !->
    [s.emit \refresh for s in socks]

  # compile everything initially
  console.log "Doing initial compile..."
  target.compile!
  cp \-Rf "assets/*" ".public/assets"

  # run express server
  console.log "Running server..."
  app = app-generator IP
  app.listen 8000

  # run socket.io server for livereload
  console.log "Running socket.io server..."
  io = require 'socket.io'
  server = http.create-server!
  server.listen 8080 IP
  socket = io.listen server

  socket.on \connection !->
    id = socks.push it
    it.on \disconnect !->
      socks := (socks.slice 0 (id - 1)) ++ (socks.slice id)

  open "http://#IP:8000"

  action = (fpath) !->
    | /(\.js|\.ls)$/.test fpath => js!
    | /\.styl$/.test fpath      => css!
    | /\.htmls$/.test fpath     => app.html!
    | /\.(jpg|png)$/.test fpath => asset fpath
    console.log "#fpath updated, refreshing..."
    refresh!

  console.log "Watching files for changes."
  <-! gaze ['src/**/*' 'styles/*.styl' 'views/*.htmls' 'assets/**/*']

  # throw errors
  throw it if it?

  @on \changed action
  @on \added action