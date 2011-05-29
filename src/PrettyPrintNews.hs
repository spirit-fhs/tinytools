module PrettyPrintNews where

import Types

prettify :: Response -> String
prettify (Response news) = unlines $ map prettifyNews news

prettifyNews :: News -> String
prettifyNews (News id title content dname classes comments cDate) =
  "> " ++ dname ++ ": " ++ title ++ " (Nr. " ++ show id
  ++ ", " ++ cDate ++ ")\n"
  ++ prettifyContent content 80 2
  ++ "\n\n"
  ++ unlines (map prettifyComment comments)

prettifyContent :: String -> Int -> Int ->  String
prettifyContent content max indent =
  let words' = words content
      step (str,len) next =
        let lenNext = length next
            lenBoth = len + lenNext
        in if lenBoth <= max
           then (str ++ " " ++ next, lenBoth)
           else (str ++ "\n" ++ replicate indent ' ' ++ next, lenNext)
  in fst $ foldl step (replicate (indent-1) ' ',0) words'

prettifyComment :: NewsComment -> String
prettifyComment (NewsComment id content dname cDate) =
  "  >> " ++ dname ++ " (Nr. " ++ show id ++ ", " ++ cDate ++ ")\n"
  ++ prettifyContent content 80 5
