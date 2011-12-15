---
title: Lesson learned from Euler Problem 104
author: Haisheng, Wu
tags: euler
---

## Solutions

There are two solutions below. One is written by me and another from haskell wiki.

They look quite similar and I can not figure out why the wiki solution can solve problem but not mine.
(Actually mine take more than 15 minutes)

* My Solution

~~~~~~~{.haskell .numberLines}
main = print $ snd $ head $ dropWhile 
                            (\(x,y) -> (not . isLastNinePandigit "123456789") x) 
                            (zip fibs [1..])

bothNinePandigit digits n =  isFirstNinePandigit digits n 
                             && isLastNinePandigit digits n

isLastNinePandigit  digits = (== digits) . sort . lastDigits 9 
isFirstNinePandigit digits = (== digits) . sort . firstDigits 9 

firstDigits k n = take k (show n)
lastDigits  k n = show (n `mod` 10^k)

~~~~~~~

* Haskell Wiki solution[^HaskellWiki]

~~~~~~~{.haskell .numberLines}
~~~~~~~


## Why the differences?

The key point here is should test start nine digits first or test end nine digits.

Two concerns here:

1. `show` function is (relatively) slow which used in test first 9 digits function.
2. quite few numbers are end in digits 1..9 in the first 329000 numbers

Therefore test last 9 digits first make great performance improvement.

**Thanks Brent explanation this sneaky thing very comprehensively in haskell-beginner.**
FIXME: link the email or full text here.

## What inspired him?

I think is the built in profile tool.

After ran, there is a p104.prof file generated which has execution time and allocation.
This is helpful for analysis.

~~~~~
# build with prof option on
ghc --make -O2 -prof -auto-all -rtsopts p104.hs

# then run
./p104 +RTS -p -RTS

~~~~~

## Further

1. Chapter 25 in Real Work Haskell about profile

[^HaskellWiki]: [Haskell Wiki Euler Problem](http://www.haskell.org/haskellwiki/Euler_problems/100_to_110)
