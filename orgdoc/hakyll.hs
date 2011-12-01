{-# LANGUAGE OverloadedStrings #-}
module Main where

import Hakyll

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler
