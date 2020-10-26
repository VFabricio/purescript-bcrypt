module Test.Main where

import Crypto.Bcrypt (Hash(..), Minor(..), Salt(..), compare, genSalt, genSaltWithMinor, getRounds, hash, hashFromSalt)
import Crypto.Bcrypt.Sync as S
import Data.String.Regex (Regex)
import Data.String.Regex as R
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Effect (Effect)
import Effect.Class (liftEffect)
import Prelude (Unit, bind, discard, ($), (==))
import Test.Unit (suite, test)
import Test.Unit.Assert (assert)
import Test.Unit.Main (runTest)

regexHash :: Regex
regexHash = unsafeRegex "^\\$2[a-b]\\$05\\$[0-9a-zA-Z\\./]{53}$" noFlags

regexHashA :: Regex
regexHashA = unsafeRegex "^\\$2a\\$05\\$[0-9a-zA-Z\\./]{53}$" noFlags

regexHashB :: Regex
regexHashB = unsafeRegex "^\\$2b\\$05\\$[0-9a-zA-Z\\./]{53}$" noFlags

regexSalt :: Regex
regexSalt = unsafeRegex "^\\$2[a-b]\\$05\\$[0-9a-zA-Z\\./]{22}$" noFlags

regexSaltA :: Regex
regexSaltA = unsafeRegex "^\\$2a\\$05\\$[0-9a-zA-Z\\./]{22}$" noFlags

regexSaltB :: Regex
regexSaltB = unsafeRegex "^\\$2b\\$05\\$[0-9a-zA-Z\\./]{22}$" noFlags

main :: Effect Unit
main = runTest do
  suite "main functions" do
    test "compare" do
       hashValue <- hash "password123" 5
       match <- compare "password123" hashValue
       assert
        "the hash matches when compared to the initial plaintext" $
        match
    test "genSalt" do
      (Salt saltText) <- genSalt 5
      assert
       "the salt contains the correct number of rounds and the correct prefix" $
       R.test regexSalt saltText

    test "genSaltWithMinor" do
      (Salt saltTextA) <- genSaltWithMinor 5 A
      assert
       "the salt includes the version a prefix" $
       R.test regexSaltA saltTextA

      (Salt saltTextB) <- genSaltWithMinor 5 B
      assert
       "the salt includes the version b prefix" $
       R.test regexSaltB saltTextB

    test "getRounds" do
      hashed <- hash "password123" 5
      assert
       "the hash has the correct number of rounds" $
       getRounds hashed == 5

    test "hash" do
      (Hash hashText) <- hash "password123" 5
      assert
       "the hash contains the correct number of rounds and the correct prefix" $
       R.test regexHash hashText

    test "hashFromSalt" do
      salt <- genSalt 5
      (Hash hashText) <- hashFromSalt "password123" salt
      assert
       "the hash contains the correct number of rounds and the correct prefix" $
       R.test regexHash hashText
  suite "sync variants" do
    test "compare" do
       hashValue <- liftEffect $ S.hash "password123" 5
       match <- compare "password123" hashValue
       assert
        "the hash matches when compared to the initial plaintext" $
        match
    test "genSalt" do
      (Salt saltText) <- liftEffect $ S.genSalt 5
      assert
       "the salt contains the correct number of rounds and the correct prefix" $
       R.test regexSalt saltText

    test "genSaltWithMinor" do
      (Salt saltTextA) <- liftEffect $ S.genSaltWithMinor 5 A
      assert
       "the salt includes the version a prefix" $
       R.test regexSaltA saltTextA

      (Salt saltTextB) <- liftEffect $ S.genSaltWithMinor 5 B
      assert
       "the salt includes the version b prefix" $
       R.test regexSaltB saltTextB

    test "hash" do
      (Hash hashText) <- liftEffect $ S.hash "password123" 5
      assert
       "the hash contains the correct number of rounds and the correct prefix" $
       R.test regexHash hashText

    test "hashFromSalt" do
      salt <- liftEffect $ S.genSalt 5
      (Hash hashText) <- liftEffect $ S.hashFromSalt "password123" salt
      assert
       "the hash contains the correct number of rounds and the correct prefix" $
       R.test regexHash hashText
