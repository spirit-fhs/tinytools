module PrettyPrintNews where

import Types

prettify :: Response -> String
prettify (Response news) = unlines $ map prettifyNews news

prettifyNews :: News -> String
prettifyNews (News newsid title content (Owner _ dname) _ comments _ cDate _) =
  "> " ++ dname ++ ": " ++ title ++ " (Nr. " ++ show newsid
  ++ ", " ++ cDate ++ ")\n"
  ++ prettifyContent content 80 2
  ++ "\n\n"
  ++ unlines (map prettifyComment comments)

prettifyContent :: String -> Int -> Int ->  String
prettifyContent content maxLen indent =
  let words' = words content
      step (str,len) next =
        let lenNext = length next
            lenBoth = len + lenNext
        in if lenBoth <= maxLen
           then (str ++ " " ++ next, lenBoth)
           else (str ++ "\n" ++ replicate indent ' ' ++ next, lenNext)
  in fst $ foldl step (replicate (indent-1) ' ',0) words'

prettifyComment :: NewsComment -> String
prettifyComment (NewsComment commentId content (Owner _ dname) cDate) =
  "  >> " ++ dname ++ " (Nr. " ++ show commentId ++ ", " ++ cDate ++ ")\n"
  ++ prettifyContent content 80 5
