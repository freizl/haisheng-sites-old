---
title: Quotes: Haskell Tutorial DRAFT
author: Haisheng, Wu
tags: reading,haskell
---

- Page 23

~~~~~~{.haskell}
instance (Eq a) => Eq (Tree a) where
  (Leaf x) == (Leaf y)  = x == y
  (Branch l r) == (Branch l' r') = l == l' && r == r'
  _ == _ = False

data Tree a = Leaf a | Branch (Tree a) (Tree a) deriving Eq
~~~~~~

- Polymorphic Type
  
`data Point a  = Point a a`
