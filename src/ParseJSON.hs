module ParseJSON where

import Data.Aeson ( parseJSON, json )
import Data.Aeson.Types ( parseMaybe )
import Data.Attoparsec.Lazy hiding ( take, takeWhile )
import Data.ByteString.Lazy (ByteString)

import Types

parseNewsFromString :: ByteString -> Maybe Response
parseNewsFromString s =
  case parse json s of
    (Done _ r) -> parseMaybe parseJSON r
    _ -> Nothing

