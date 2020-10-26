var bcrypt = require('bcrypt')

exports.compare = function (plaintext) {
  return function (encrypted) {
    return bcrypt.compareSync(plaintext, encrypted)
  }
}

exports.genSalt = function (rounds) {
  return function () {
    return bcrypt.genSaltSync(rounds)
  }
}

exports._genSaltWithMinor = function (decodeMinor) {
  return function (rounds) {
    return function (minor) {
      return function () {
        return bcrypt.genSaltSync(rounds, decodeMinor(minor))
      }
    }
  }
}

var bcryptHash = function (plaintext) {
  return function (saltOrRounds) {
    return function () {
      return bcrypt.hashSync(plaintext, saltOrRounds)
    }
  }
}

exports.hash = bcryptHash
exports.hashFromSalt = bcryptHash
