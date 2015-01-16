import Data.Digest.Pure.SHA
import Data.ByteString.Lazy.Char8 (pack) 
import Data.List (find)
--Oscar Felipe Toro as a mandatory assignment to WebSecurity course 2014 at KEA
source = ['a'..'z'] ++ ['0'..'9'] ++ ['A'..'Z']-- ++ ['ø','æ','å','Ø','Æ','Å']
ln = [1..5] :: [Int] 
--encode to SHA1
encode xs = sha1 (pack xs)
--compare the hash(attribute p) with the generated word of length n 
inspect :: [Char] -> Int -> Maybe [Char]
inspect p n = find (\x -> (showDigest $ encode x) == p) (allWords n)
--finds passwords
bruteforce pass = smash pass ln where  
  smash xs (hd:tl) = case inspect xs hd  of
                       Nothing  -> smash xs tl
                       Just r   -> [r]
--generate combination of words from source variable                            
allWords 0 = [""]
allWords n = [c:w | w <- (allWords (n - 1)), c <- source]
