require 'shelljs/global'
require! {
  \express
  \htmls
}

server = express!
server.use express.static __dirname + '/.public'
server-ip = void
tmpl-path = './views/index.htmls'
template = htmls cat tmpl-path

server.html = !->
  template := htmls cat tmpl-path

server.get '/' (req, res) !->
  res.end template {+dev-mode, ip: server-ip}

test-server = (ip) ->
  server-ip := ip
  server

module.exports = test-server