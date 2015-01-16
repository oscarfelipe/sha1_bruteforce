#Brute force attack to SHA1 hashed passwords
bruteforce is a Haskell script that issue a brute force attack to sha1-hashed password
of infinite length. There are two version of the script: a slow version called bs.hs and an optimised version called bs2.hs

##Installation
in order to run the functions, an installation of the Glorious Haskell Compiler is required(ghc).[https://www.haskell.org/platform/]
##Selecting the script
on the folder of the project call ghci on the console:
cd ../bruteforce
ghci bf.hs

ghci is going to load the script bf.hs. In order to test bf2.hs you can perform the following comand in ghci:
:load bf2.hs
and the ghc interpreter is going to use the bf2.hs functions
##Use
bruteforce only accepts strings, so this are correct uses of the bruteforce function:
Main>bruteforce "e175ea4ce0a553260a14bc5e922a935b40425c1e"
Main>["ab1"]

Main>bruteforce "9ee036287b4cfbcfa3b5bbfcf92d46eb5e75df96"
Main>["abc1"]

Main>bruteforce "d8105747facd7558aca4559169590ada33e4aca0"
Main>["abcd1"]

Main>bruteforce "2dff4fc90e2973f54d62e257480de234bc59e2c4"
Main>["oscar"]

##bf.hs
###Explanation of the source code
####source
generate the alphanumeric source of characters where the potential passwords are going to be created from.

####ln
stands for length which is going to defin the length of the password. We use the lazy attributes of Haskell to generate a list of infinites Int. In this case the type is defined in order to type check the function bruteforce which is expecting to receive Int instead of Integer types. An improvement of this function could be to start from 0 since is not included.

####encode
Haskell evaluate from right to left. The first function evaluated is pack xs which is going to pack a list of characters ([Char) into ByteString Data Type. I do so, because sha1 is expecting a ByteString which is the next function to be called. _sha1_ is going to hash the previous result into a hash SHA1 value. This value is of type Digest SHA1.
####jkarni1
This function is not used but has the same functionality as _allWords_. Which is generating all the possible words from a list of characters with a length specified in the parameter n.
the dollar sign ($) in Haskell is analogue to the Unix pipe (|) it takes the result of _replicate n xs_ which is going to repeat n times the list xs. In Haskell replicate 2 "ab1" = ["ab1","ab1"]. This result is taken by the function _sequence_ which is going to generate all the possibible combinations between the list. Similar as in the previous example, encode "ab1" = ["aa","ab","a1","ba","bb","b1","1a","1b","11"]. And all this computation is made in only one line of code, simply outstanding.

####inspect
Takes two parameters, p and n. The variable p stands for password and n for number which is the lenght of the password to be compared. The function _filter_ check ALL the possible matches between the hashed password and my collection of words, that is why is going to take so long to compute the result for more than 3 character hashed password. Because is not going to end until compare every single password. This problem is solved in bf2.hs. The function _filter_ takes a lambda expresion, which has to be a predicate, and a list. As I explained before, I need to use showDigest to compute the result of _encode x_ to cast the type Digest SHA1 into a String. A String data type in Haskell is also a list of characters data type [Char]. Sumarizing, inspect is going to filter the values of a list if the hash is equal to the hashed generated word and is not going to end until all the generated words are reached.

####brute force
Takes a password as a parameter. The password has to be of type [Char]. A correct example of use is in ghci is the following:
bruteforce "e175ea4ce0a553260a14bc5e922a935b40425c1e" which returns ["ab1"]. This functions uses an auxiliar function defined with the Haskell keyword _where_. The idea here is that the user only pass the hashed password and the function is going to pattern match the result of _inspect_ lazily, that is, as soon one of the possible results is reached. The problem here is that since the list is lazy, an incorrect hashed value is never going to end.To solve this, on line 5 ln can be defined as ln = [1..5] :: [Int] in order to stop the computation if the result was not founded until passwords of 5 characters are inspected. In Haskell we pattern match with the statement _case_ somethingToPaternmatch _of_ which is going to inspect the result of the function _inspect xs hd_. I am passing an infinite list to define the length of the words to be generated, and use the head of this list to use as the _n_ variable of the function _inspect_. If the result returns an empty list, this means that no password was matched with one character so is going to try recursively taking the next value of the list, namely 2 until something is returned from _inspect xs hd_, which is the second case _[r] -> [r]_. When this is the case, is going to return this result. 

####allWords
Is the recursive implementation of _jkarni1_ using list comprehensions. List comprehensions are very similar to SQL statements. In the recursive case a list comprehension is defined.Is going to generate a list with elements of type c:w,where _c_ is one element of _source_(a..z1..0). The colon (:) is called cons and express the concatenation of two elements of a list. The value _w_ contains the recursive call substracting one to get a list of less and less elements, until the function hits the empty list of characters and return the result. A correct use of this function in ghci is the following: allWords 2 which is going to return ["aa","ba".."99"]

##bf2.hs
The only difference with bf.hs is that here I am using _find_ in inspect rather than filter. filter is using the Maybe monad, which means that the result is maybe going to be a list of characters(_Just r_) or _Nothing_. That is why I have to change the implementation of bruteforce in order to patern match the correct values. The problem here is that the script is going to run for ever if no correct value is finded, on the other hand, it performs much better than the previous script since it returns the first value that encounter in the list of words.That is why in this case I use a finite list of 5 elements, but I guess that it is going to run forever because the only two possibles return cases are _Nothing_ or _Just r_.
