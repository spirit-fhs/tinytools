{-# LANGUAGE OverloadedStrings #-}
module Types where

import Data.Aeson ( FromJSON, parseJSON, Value(Object), (.:) )
import Control.Applicative ( (<$>), (<*>) )
import Control.Monad ( mzero )

newtype Response = Response { responseNews :: [News] }
  deriving (Show)

instance FromJSON Response where
  parseJSON (Object v) =
    Response <$> v .: "news"
  parseJSON _ = mzero

-- TODO: parse Time
data News = News
  { newsId :: Integer
  , newsTitle :: String
  , newsContent :: String
  , newsOwner :: Owner
  , newsClasses :: [Class]
  , newsComments :: [NewsComment]
  , newsExpireDate :: String
  , newsCreationDate :: String
  , newslastModified :: String
  }
    deriving (Show)

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

data Owner = Owner
  { ownerFhs_id :: String
  , ownerDisplayedName :: String
  }
    deriving (Show)

instance FromJSON Owner where
  parseJSON (Object v) =
    Owner <$>
      v .: "fhs_id" <*>
      v .: "displayedName"
  parseJSON _ = mzero

data Class = Class
  { classTitle :: String
  , classClass_id :: Integer
  , classMail :: String
  }
    deriving (Show)

instance FromJSON Class where
  parseJSON (Object v) =
    Class <$>
      v .: "title" <*>
      v .: "class_id" <*>
      v .: "mail"
  parseJSON _ = mzero

-- TODO: parse Time
data NewsComment = NewsComment
  { newsCommentId :: Integer
  , newsCommentContent :: String
  , newsCommentOwner :: Owner
  , newsCommentCreationDate :: String
  }
    deriving (Show)

instance FromJSON NewsComment where
  parseJSON (Object v) =
    NewsComment <$>
      v .: "comment_id" <*>
      v .: "content" <*>
      v .: "owner" <*>
      v .: "creationDate"
  parseJSON _ = mzero

