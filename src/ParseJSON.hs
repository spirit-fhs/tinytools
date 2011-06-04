{-# LANGUAGE OverloadedStrings #-}
module ParseJSON where

import Data.Aeson
import qualified Data.Aeson.Types as T
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Data.Attoparsec.Lazy hiding (take, takeWhile)
import Data.Text (Text, pack)
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Char8 as BS

import Types

instance FromJSON Response where
  parseJSON (Object v) =
    Response <$> v .: "news"

instance FromJSON News where
  parseJSON (Object v) =
    News <$>
      v .: "news_id" <*>
      v .: "title" <*>
      v .: "content" <*>
      v .: "displayedName"  <*>
      v .: "classes"  <*>
      v .: "newsComments" <*>
      v .: "creationDate"
  parseJSON _ = mzero

instance FromJSON Class where
  parseJSON (Object v) =
    Class <$> v .: "title"

instance FromJSON NewsComment where
  parseJSON (Object v) =
    NewsComment <$>
      v .: "id" <*>
      v .: "content" <*>
      v .: "displayedName" <*>
      v .: "creationDate"
  parseJSON _ = mzero

-- parseNewsFromString :: String -> Maybe Response
parseNewsFromString s =
  case parse json s of
    (Done rest r) -> T.parseMaybe parseJSON r :: Maybe Response
    _ -> Nothing

