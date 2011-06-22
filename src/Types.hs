{-# LANGUAGE OverloadedStrings #-}
module Types where

import Data.Aeson ( FromJSON, parseJSON, Value(Object, String), (.:) )
import Control.Applicative ( (<$>), (<*>), pure )
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
  , newsClasses :: [DegreeClass]
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
  , memberType :: MemberType
  }
    deriving (Show)

instance FromJSON Owner where
  parseJSON (Object v) =
    Owner <$>
      v .: "fhs_id" <*>
      v .: "displayedName" <*>
      v .: "memberType"
  parseJSON _ = mzero

data MemberType = Lecturer | Student
    deriving (Show)

instance FromJSON MemberType where
  parseJSON (String "Lecturer") = pure Lecturer
  parseJSON (String "Student")  = pure Student
  parseJSON _ = mzero

data DegreeClass = DegreeClass
  { classTitle :: String
  , classClass_id :: Integer
  , classType :: ClassType
  , classMail :: Maybe String
  }
    deriving (Show)

instance FromJSON DegreeClass where
  parseJSON (Object v) =
    DegreeClass <$>
      v .: "title" <*>
      v .: "class_id" <*>
      v .: "classType" <*>
      v .: "mail"
  parseJSON _ = mzero

data ClassType = RootClass | Class | Group
    deriving (Show)

instance FromJSON ClassType where
  parseJSON (String "RootClass") = pure Class
  parseJSON (String "Class") = pure Class
  parseJSON (String "Group") = pure Group
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

