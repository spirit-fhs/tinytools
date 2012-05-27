{-# LANGUAGE DeriveDataTypeable #-}
module Main where

import Data.Typeable ( Typeable )
import Control.Exception ( handleJust, throw, Exception )
import System.Environment ( getArgs, getProgName )

import AskSpirit

main :: IO ()
main = do
  args <- getArgs
  handleJust (const $ Just () :: UsageException -> Maybe ()) usage $
    if    null args
       || "-h" `elem` args
       || "-x" `elem` args
          && "-p" `elem` args
    then throw UsageException
    else
      let (acceptXML,prettyPrint,arg) = case args of
            ("-x":[])     -> throw UsageException
            ("-x":arg':_) -> (True,  False, arg')
            ("-p":[])     -> throw UsageException
            ("-p":arg':_) -> (False, True,  arg')
            (arg':_)      -> (False, False, arg')
            _             -> throw UsageException
      in spiritnews arg acceptXML prettyPrint

data UsageException = UsageException
  deriving (Show, Typeable)

instance Exception UsageException

usage :: () -> IO ()
usage _ = do
  pname <- getProgName
  putStrLn $ "Usage: " ++ pname ++ " [-x|-h|-p] query"
  putStrLn   "  -h   this message"
  putStrLn   "  -p   pretty print JSON"
  putStrLn   "  -x   get XML instead of JSON"
  putStrLn $ "Example: " ++ pname ++ " news/1"

