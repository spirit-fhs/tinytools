module Main where

import System.Environment
import AskSpirit

main = do
  args <- getArgs
  let (acceptXML,arg) = case args of
    ("-x":arg':_) -> (True, arg')
    (arg':_)      -> (False,arg')
  spiritnews arg acceptXML

