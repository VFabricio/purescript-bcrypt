module Crypto.Bcrypt.Sync
  ( compare
  , genSalt
  , genSaltWithMinor
  , hash
  , hashFromSalt
  )
where

import Crypto.Bcrypt (Hash, Minor, Salt, minorToString)
import Effect (Effect)

-- compare --

foreign import compare :: String -> Hash -> Boolean

-- genSalt --

foreign import genSalt :: Int -> Effect Salt

-- genSaltWithMinor --

foreign import _genSaltWithMinor :: (Minor -> String) -> Int -> Minor -> Effect Salt

genSaltWithMinor :: Int -> Minor -> Effect Salt
genSaltWithMinor = _genSaltWithMinor minorToString

-- hash --

foreign import hash :: String -> Int -> Effect Hash

-- hashFromSalt --

foreign import hashFromSalt :: String -> Salt -> Effect Hash
