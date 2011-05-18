module Main where

import Network.HTTP
import Network.HTTP.Headers
import System.Environment

main = do
    args <- getArgs
    let (hdr,args') = case args of
          ("-x":args'') -> (mkHeader HdrAccept "application/xml",args'')
          _             -> (mkHeader HdrAccept "application/json",args)
    rsps <- mapM (simpleHTTP . flip setHeaders [hdr] . getRequest .
       ("http://spiritdev.fh-schmalkalden.de/database/"++)) args'
    bodies <- mapM getResponseBody rsps
    mapM_ putStrLn bodies
