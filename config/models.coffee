##
# Sequelizeを利用してMySQLに接続します
# passwordはsha1で保存する想定です
# DB情報はconfig.jsonを編集します
##

Sequelize = require 'sequelize'
db = require "#{__dirname}/config.json"

sequelize = new Sequelize db.name, db.user, db.pass,
  logging: (arg) ->
    # 79文字以降のログを削除します
    console.log arg.toString().substr(0, 79)
  # trueにすると、起動時にTableをリセットします
  sync: force: no
  define:
    syncOnAssociation: yes
    underscored: yes
    charset: 'utf8'
    collate: 'utf8_general_ci'

CheckSum = (hash) ->
  unless hash.match /[0-9a-f]{,40}/i
    throw new Error "#{hash} appears to be NOT sha1."

Models =
  User:
    sequelize.define 'user',
      username:
        type: Sequelize.STRING
        unique: yes
        allowNull: no
      password:
        type: Sequelize.STRING
        validate: isHash: CheckSum
        allowNull: no

model.sync() for index, model of Models
module.exports = Models