{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy as L
import System.Environment
import ParseJSON (parseNewsFromString)
import PrettyPrintNews (prettify)

baseurl="https://212.201.64.226:8443/fhs-spirit/"

main = do
  args <- getArgs
  let (acceptXML,arg) = case args of
        ("-x":arg':_) -> (True, arg')
        (arg':_)      -> (False,arg')
  req0 <- parseUrl $ baseurl ++ arg
  let req = req0 { method = methodGet
                 , requestHeaders = if acceptXML
                                    then [("Accept", "application/xml")]
                                    else [("Accept", "application/json")]
                 , checkCerts = const $ return True
                 }
  res <- withManager $ httpLbs req
  if acceptXML
    then L.putStrLn $ responseBody res
    else parseAndPrint $ responseBody res

parseAndPrint jsonString =
  case parseNewsFromString jsonString of
    Just news -> putStr $ prettify news
    Nothing -> do putStrLn $ "Error: not parsable\n"
                  L.putStrLn jsonString
