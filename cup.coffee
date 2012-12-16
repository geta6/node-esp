# Modules

http = require 'http'
crypto = require 'crypto'
logger = require 'consolable'
express = require 'express'
connect =
  flash: require 'connect-flash'
  assets: require 'connect-assets'
  session: (require 'connect-mongo') express


# Passport

passport = require 'passport'
{Strategy} = require 'passport-local'

Model = require './config/models'

passport.serializeUser (user, done) ->
  # シリアライズします
  done null, user.id

passport.deserializeUser (id, done) ->
  # DBからユーザ情報を引っ張ってきます
  Model.User.find(id).success (user) ->
    done null, user

passport.use new Strategy (username, password, done) ->
  process.nextTick ->
    # 認証機構
    # `return done null, user`とすれば認証成功
    # serializeにuserが送信されます
    Model.User.find(where:username:username).success (user) ->
      if user is null
        return done null, no, message: 'そんなユーザ存在しません'
      else
        unless password.match /^[0-9a-f]{40}$/ig
          password = crypto.createHash('sha1').update(password).digest('hex')
        if user.password is password
          return done null, user
        else
          return done null, no, message: 'EPASWD'

# 返り値は関数、認証開始をフックします
authenticate = passport.authenticate 'local',
  failureRedirect: '/signin'
  failureFlash: yes

# 認証しているかどうかを判断します
ensure = (req, res, next) ->
  return res.redirect '/signin' unless req.isAuthenticated
  next()


# Express

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.logger 'dev'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session
    secret: 'keyboard cat'
    store: new connect.session(db: 'session_store')
  app.use connect.flash()
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use connect.assets()
  app.use express.static "#{__dirname}/public"

app.get '/', (req, res) ->
  res.render 'index', req: req

app.get '/signin', (req, res) ->
  res.render 'signin', req: req

# passport.useされたメソッドを適用して認証を開始します
# 成功するとres.redirect '/'が評価されます
app.post '/signin', authenticate, (req, res) ->
  res.redirect '/'

# ログインしていないと/signinにリダイレクトされます
app.get '/signout', ensure, (req, res) ->
  req.logout()
  res.redirect '/'

http.createServer(app).listen (app.get 'port'), ->
  console.info "coffee cupped on #{app.get 'port'}"