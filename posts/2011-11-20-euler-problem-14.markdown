---
title: Solving Euler Problem 14
author: Haisheng, Wu
tags: haskell, euler
---


## Solution One

I should say this solution only work while upper limit is under 100000.
Otherwise it is really slow and I have no pasient for the result.
I wonder it would take minutes or even hours.

So, problem solving failed.

~~~~~
module Main where
import Data.Word
    
main :: IO ()
main = print $ p14

p14 = maximum [ (startChain n 0, n) | n <- [2..1000000] ]

startChain :: Int -> Int -> Int
startChain 1 count    = count + 1
startChain n count    = startChain (intTransform n) (count+1)
                    
intTransform :: Int -> Int
intTransform n
  | even n         = n `div` 2 
  | otherwise      = 3 * n + 1 

~~~~~

## Solution Two

I went for Haskell Wiki[^HaskellWiki] for help by finding solution one here is similar to one of its solutions.
The significate difference is it uses type `Word32` for `n` rather than `Int`.
I picked this difference and updated solution one into follow and it worked out really cool.

The result came under 1.5s at my local!

?? what is the link opts..seems due to how to link (compile) it.

~~~~~
module Main where
import Data.Word
    
main :: IO ()
main = print $ p14

p14 = maximum [ (startChain n 0, n) | n <- [2..1000000] ]

startChain :: Word32 -> Int -> Int
startChain 1 count    = count + 1
startChain n count    = startChain (intTransform n) (count+1)
                    
intTransform :: Word32 -> Word32
intTransform n
  | even n         = n `div` 2 
  | otherwise      = 3 * n + 1 

~~~~~

## Other solution

Haskell Wiki[^HaskellWiki] presents several solutions. 
One interested me is that levearages parallel programming `Control.Parallel`.

[^HaskellWiki]: [Haskell Wiki Euler Problem](https://github.com/freizl/dive-into-haskell/tree/master/prime)
