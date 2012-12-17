# Modules

http = require 'http'
logger = require 'consolable'
express = require 'express'
connect =
  assets: require 'connect-assets'


# Express

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use connect.assets()
  app.use express.static "#{__dirname}/public"

app.get '/', (req, res) ->
  res.render 'index', req: req

http.createServer(app).listen (app.get 'port'), ->
  console.info "coffee cupped on #{app.get 'port'}"
