module Types where

newtype Response = Response { responseNews :: [News] }
  deriving (Show)

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

data Owner = Owner
  { ownerFhs_id :: String
  , ownerDisplayedName :: String
  }
    deriving (Show)

data Class = Class
  { classTitle :: String
  , classClass_id :: Integer
  , classMail :: String
  }
    deriving (Show)

-- TODO: parse Time
data NewsComment = NewsComment
  { newsCommentId :: Integer
  , newsCommentContent :: String
  , newsCommentOwner :: Owner
  , newsCommentCreationDate :: String
  }
    deriving (Show)


