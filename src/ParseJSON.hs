{-# LANGUAGE OverloadedStrings #-}
module ParseJSON where

import Data.Aeson
import qualified Data.Aeson.Types as T
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Data.Attoparsec hiding (take, takeWhile)
import Data.Text (Text, pack)
import qualified Data.ByteString.Char8 as BS

newtype Response = Response { responseNews :: [News] }
  deriving (Show)

instance FromJSON Response where
  parseJSON (Object v) =
    Response <$> v .: "news"

-- TODO: parse Time
data News = News { newsId :: Integer
                 , newsTitle :: String
                 , newsContent :: String
                 , newsDisplayedName :: String
                 , newsClasses :: [Class]
                 , newsComments :: [NewsComment]
                 , newsCreationDate :: String
                 }
  deriving (Show)

instance FromJSON News where
  parseJSON (Object v) =
    News <$>
      v .: "id" <*>
      v .: "title" <*>
      v .: "content" <*>
      v .: "displayedName"  <*>
      v .: "classes"  <*>
      v .: "newsComments" <*>
      v .: "creationDate"
  parseJSON _ = mzero

newtype Class = Class { classTitle :: String }
  deriving (Show)

instance FromJSON Class where
  parseJSON (Object v) =
    Class <$> v .: "title"

-- TODO: parse Time
data NewsComment = NewsComment { newsCommentId :: Integer
                               , newsCommentContent :: String
                               , newsCommentDisplayedName :: String
                               , newsCommentCreationDate :: String
                               }
  deriving (Show)

instance FromJSON NewsComment where
  parseJSON (Object v) =
    NewsComment <$>
      v .: "id" <*>
      v .: "content" <*>
      v .: "displayedName" <*>
      v .: "creationDate"
  parseJSON _ = mzero

parseNewsFromString :: String -> Maybe Response
parseNewsFromString s =
  let bs = BS.pack s
  in case parse json bs of
    (Done rest r) -> T.parseMaybe parseJSON r :: Maybe Response
    _ -> Nothing

