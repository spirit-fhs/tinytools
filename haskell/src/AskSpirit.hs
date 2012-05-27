{-# LANGUAGE OverloadedStrings #-}
module AskSpirit where

import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy as L

import ParseJSON ( parseNewsFromString )
import PrettyPrintNews (prettify)
import Network.TLS (TLSCertificateUsage (CertificateUsageAccept))

baseurl :: String
baseurl = "https://212.201.64.226:8443/fhs-spirit/"

spiritnews :: String -> Bool -> Bool -> IO ()
spiritnews arg acceptXML prettyPrint  = do
  req0 <- parseUrl $ baseurl ++ arg
  let req = req0 { method = methodGet
                 , requestHeaders =
                     if acceptXML
                     then [("Accept", "application/xml")]
                     else [("Accept", "application/json")]
                 , checkCerts = const $ return CertificateUsageAccept
                 }
  res <- withManager $ httpLbs req
  if acceptXML || not prettyPrint
    then L.putStrLn $ responseBody res
    else parseAndPrint $ responseBody res

parseAndPrint :: L.ByteString -> IO ()
parseAndPrint jsonString =
  case parseNewsFromString jsonString of
    Just news -> putStr $ prettify news
    Nothing -> do
      putStrLn $ "Error: not parsable\n"
      L.putStrLn jsonString
