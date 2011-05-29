module Types where

newtype Response = Response { responseNews :: [News] }
  deriving (Show)

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

newtype Class = Class { classTitle :: String }
  deriving (Show)

-- TODO: parse Time
data NewsComment = NewsComment { newsCommentId :: Integer
                               , newsCommentContent :: String
                               , newsCommentDisplayedName :: String
                               , newsCommentCreationDate :: String
                               }
  deriving (Show)


