import Data.Digest.Pure.SHA
import Data.ByteString.Lazy.Char8 (pack) 
--Oscar Felipe Toro as a mandatory assignment to WebSecurity course 2014 at KEA
source = ['a'..'z'] ++ ['0'..'9']-- ['A'..'Z'] ++ ['ø','æ','å','Ø','Æ','Å']
ln = [1..] :: [Int] --lazy infinite list of Int
--encode to SHA1
encode xs = sha1 (pack xs)
--currently not using this function, but couldn't delete it due to its beauty
jkarni1 n xs = sequence $ replicate n xs
--compare hashed string with allWords
inspect :: [Char] -> Int -> [[Char]]
inspect p n = filter (\x -> (showDigest $ encode x) == p) (allWords n)
-- find passwords
bruteforce pass = smash pass ln where  
  smash xs (hd:tl) = case inspect xs hd  of
                       []  -> smash xs tl
                       [r] -> [r]
                       _   -> ["password not founded"]
           
allWords 0 = [""]
allWords n = [c:w | w <- (allWords (n - 1)), c <- source]
