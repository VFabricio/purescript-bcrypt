var bcrypt = require('bcrypt')

var canceler = function (cancelError, cancelerError, cancelerSuccess) {
  cancelerSuccess()
}

var promiseToCallback = function (promise, onError, onSuccess) {
  promise.then(function (result) {
    onSuccess(result)
  }).catch(function (err) {
    onError(err)
  })
}

exports._compare = function (plaintext) {
  return function (encrypted) {
    return function (onError, onSuccess) {
      promiseToCallback(bcrypt.compare(plaintext, encrypted), onError, onSuccess)
    }

    return canceler
  }
}

exports._genSalt = function (rounds) {
  return function (onError, onSuccess) {
    promiseToCallback(bcrypt.genSalt(rounds), onError, onSuccess)

    return canceler
  }
}

exports._genSaltWithMinor = function (decodeMinor) {
  return function (rounds) {
    return function (minor) {
      return function (onError, onSuccess) {
        promiseToCallback(bcrypt.genSalt(rounds, decodeMinor(minor)), onError, onSuccess)

        return canceler
      }
    }
  }
}

exports.getRounds = bcrypt.getRounds

var bcryptHash = function (plaintext) {
  return function (saltOrRounds) {
    return function (onError, onSuccess) {
      promiseToCallback(bcrypt.hash(plaintext, saltOrRounds), onError, onSuccess)

      return canceler
    }
  }
}

exports._hash = bcryptHash
exports._hashFromSalt = bcryptHash
