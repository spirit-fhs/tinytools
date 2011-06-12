{-# LANGUAGE OverloadedStrings #-}
module ParseJSON where

import Data.Aeson
import qualified Data.Aeson.Types as T
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Data.Attoparsec.Lazy hiding (take, takeWhile)
import Data.Text (Text, pack)

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
      v .: "owner"  <*>
      v .: "degreeClass"  <*>
      v .: "newsComment" <*>
      v .: "expireDate" <*>
      v .: "creationDate" <*>
      v .: "lastModified"
  parseJSON _ = mzero

instance FromJSON Owner where
  parseJSON (Object v) =
    Owner <$>
      v .: "fhs_id" <*>
      v .: "displayedName"

instance FromJSON Class where
  parseJSON (Object v) =
    Class <$>
      v .: "title" <*>
      v .: "class_id" <*>
      v .: "mail"

instance FromJSON NewsComment where
  parseJSON (Object v) =
    NewsComment <$>
      v .: "comment_id" <*>
      v .: "content" <*>
      v .: "owner" <*>
      v .: "creationDate"
  parseJSON _ = mzero

parseNewsFromString s =
  case parse json s of
    (Done rest r) -> T.parseMaybe parseJSON r :: Maybe Response
    _ -> Nothing

