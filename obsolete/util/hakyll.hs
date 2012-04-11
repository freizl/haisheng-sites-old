{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad(forM_)
import Hakyll

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
      route   idRoute
      compile compressCssCompiler
    -- Static directories
    forM_ ["*.html", "images/*", "*/*.html"] $ \f -> match f $ do
      route   idRoute
      compile copyFileCompiler
