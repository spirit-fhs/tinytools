module Main where

import Network.HTTP
import Network.HTTP.Headers
import System.Environment
import ParseJSON (parseNewsFromString)
import PrettyPrintNews (prettify)

main = do
    args <- getArgs
    let (hdr,args') = case args of
          ("-x":args'') -> (mkHeader HdrAccept "application/xml",args'')
          _             -> (mkHeader HdrAccept "application/json",args)
    rsps <- mapM (simpleHTTP . flip setHeaders [hdr] . getRequest .
       ("http://spiritdev.fh-schmalkalden.de/database/"++)) args'
    bodies <- mapM getResponseBody rsps
    parseAndPrint bodies

parseAndPrint =
  mapM_ (\jsonString ->
           case parseNewsFromString jsonString of
             Just news -> putStr $ prettify news
             Nothing -> putStrLn $ "Error: not parsable\n" ++ jsonString)
