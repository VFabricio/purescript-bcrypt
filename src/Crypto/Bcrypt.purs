module Crypto.Bcrypt
  ( Hash(..)
  , Salt(..)
  , Minor(..)
  , compare
  , genSalt
  , genSaltWithMinor
  , getRounds
  , hash
  , hashFromSalt
  , minorToString
  )
where

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Prelude (($))

-- General --

newtype Hash = Hash String
newtype Salt = Salt String

data Minor = A | B

minorToString :: Minor -> String
minorToString A = "a"
minorToString B = "b"

-- compare --

foreign import _compare :: String -> Hash -> EffectFnAff Boolean

compare :: String -> Hash -> Aff Boolean
compare plaintext hashed = fromEffectFnAff $ _compare plaintext hashed

-- genSalt --

foreign import _genSalt :: Int -> EffectFnAff Salt

genSalt :: Int -> Aff Salt
genSalt rounds = fromEffectFnAff $ _genSalt rounds

-- genSaltWithMinor --

foreign import _genSaltWithMinor :: (Minor -> String) -> Int -> Minor -> EffectFnAff Salt

genSaltWithMinor :: Int -> Minor -> Aff Salt
genSaltWithMinor rounds minor = fromEffectFnAff $ _genSaltWithMinor minorToString rounds minor

-- getRounds --
foreign import getRounds :: Hash -> Int

-- hash --

foreign import _hash :: String -> Int -> EffectFnAff Hash

hash :: String -> Int -> Aff Hash
hash plaintext rounds = fromEffectFnAff $ _hash plaintext rounds

-- hashFromSalt --

foreign import _hashFromSalt :: String -> Salt -> EffectFnAff Hash

hashFromSalt :: String -> Salt -> Aff Hash
hashFromSalt plaintext salt = fromEffectFnAff $ _hashFromSalt plaintext salt
