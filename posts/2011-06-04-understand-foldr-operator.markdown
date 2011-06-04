---
title: Understand foldr operator
author: Haisheng, Wu
tags: haskell, fold
---

I can not quite remember the usage of foldr until I finish the video by Erik Meijer on <Programming in Haskell> Chapter 7[^meijer-pih].
Erik describe `foldr` in a very comprehensive way. 

Take refining the `length` function in terms of `foldr` as a example.
`length` has a definition as

~~~~~
> length  :: [a] -> Int
> length []  = 0
> length (x:xs)   = 1 + length xs
~~~~~

and

~~~~~
  length [1,2,3]
= length (1:(2:(3:[])))
= 1 + (1 + (1  + 0))
= 3
~~~~~

By replace each (:) by `\ _ n -> 1 + n` and [] by 0, we have:

~~~~~
> length = foldr (\ _ n -> 1 + n) 0
~~~~~

Having such knowledge inside, I find Graham's tutorial paper[^ghutton] about fold again.
There is a concise decription of what fold is:

> The function _fold f v_ processes a list of type _[a]_ to give a value of type _b_ 
> by replacing the _nil_ constructor [] at the end of the list by the value _v_, 
> and each cons constructor (:) within the list by the function _f_.

In Haskell, the _fold_ operator can be defined as follows:

~~~~~
fold  :: (a -> b -> b) -> b -> [a] -> b
fold f v [] = v
fold f v (x:xs) = f x (fold f v xs)
~~~~~

[^meijer-pih]: [Programming in Haskell](http://www.cs.nott.ac.uk/~gmh/book.html)
[^ghutton]: [Tutorial on the universality and expressions of fold](www.cs.nott.ac.uk/~gmh/fold.pdf)
