{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Arrow ((>>>), (***), arr)
import Control.Monad(forM_)
import Prelude hiding (id)
import Control.Category (id)
import Data.Monoid (mempty, mconcat)
import Text.Pandoc
import Hakyll

postsWildcardMatch = "posts/**/*"

main :: IO ()
main = hakyllWith config $ do
    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Static directories
    match ("images/*" .||. "codes/*") $ do
        route   idRoute
        compile copyFileCompiler

    --
    match "sidebar.md" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler

    forM_ ["cv.md", "cv-full.md"] $ \f -> match f $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
              >>= loadAndApplyTemplate "templates/default.html"
              >>= relativizeUrls

    -- just copy pre-compiled slides.
    match "slides/*.html" $ do
        route   $ idRoute
        compile $ copyFileCompiler

    -- Render posts
    match postsWildcardMatch $ do
        route   $ setExtension ".html"
        compile $ pandocCompilerWith
            >>= arr (renderDateField "date" "%B %e, %Y" "Date unknown")
            >>= renderTagsField "prettytags" (fromCapture "tags/*")
            >>= loadAndApplyTemplate "templates/post.html"
            >>= loadAndApplyTemplate "templates/default.html"
            >>= relativizeUrls

    -- Render posts list
    match "posts.html" $ route idRoute
    create "posts.html" $ constA mempty
        >>= arr (setField "title" "All posts")
        >>= requireAllA postsWildcardMatch addPostList
        >>= loadAndApplyTemplate "templates/posts.html"
        >>= loadAndApplyTemplate "templates/default.html"
        >>= relativizeUrls

    -- Index
    match "index.html" $ route idRoute
    create "index.html" $ constA mempty
        >>= arr (setField "title" "Home")
        >>= requireA "sidebar.md" (setFieldA "index" $ arr pageBody)
        >>= requireA "tags" (setFieldA "tagcloud" (renderTagCloud'))
        >>= requireAllA postsWildcardMatch (id *** arr (take 9 . reverse . chronological) >>= addPostList)
        >>= loadAndApplyTemplate "templates/index.html"
        >>= loadAndApplyTemplate "templates/default.html"
        >>= relativizeUrlsCompiler

    -- Tags
    create "tags" $
        requireAll postsWildcardMatch (\_ ps -> readTags ps :: Tags String)

    -- Add a tag list compiler for every tag
    match "tags/*" $ route $ setExtension ".html"
    metaCompile $ require_ "tags"
        >>= arr tagsMap
        >>= arr (map (\(t, p) -> (tagIdentifier t, makeTagList t p)))

    -- Render RSS feed
    match "rss.xml" $ route idRoute
    create "rss.xml" $
        requireAll_ postsWildcardMatch
            >>= mapCompiler (arr $ copyBodyToField "description")
            >>= renderRss feedConfiguration

    -- Read templates
    match "templates/*" $ compile templateCompiler

  where
    renderTagCloud' :: Compiler (Tags String) String
    renderTagCloud' = renderTagCloud tagIdentifier 100 120

    tagIdentifier :: String -> Identifier (Page String)
    tagIdentifier = fromCapture "tags/*"

    pageCompilerWithToc = pandocCompilerWith defaultHakyllParserState withToc

    withToc = defaultHakyllWriterOptions
        { writerTableOfContents = True
        , writerTemplate = "<h2 id=\"TOC\">TOC</h2>\n$toc$\n$body$"
        , writerStandalone = True
        }

-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
addPostList :: Compiler (Page String, [Page String]) (Page String)
addPostList = setFieldA "posts" $
    arr (reverse . chronological)
        >>= require "templates/postitem.html" (\p t -> map (applyTemplate t) p)
        >>= arr mconcat
        >>= arr pageBody

makeTagList :: String
            -> [Page String]
            -> Compiler () (Page String)
makeTagList tag posts =
    constA (mempty, posts)
        >>= addPostList
        >>= arr (setField "title" ("Posts tagged &#8216;" ++ tag ++ "&#8217;"))
        >>= loadAndApplyTemplate "templates/posts.html"
        >>= loadAndApplyTemplate "templates/default.html"

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Haisheng's Tech Blog RSS feed."
    , feedDescription = "Haisheng's Tech Blog."
    , feedAuthorName  = "Haisheng Wu"
    , feedRoot        = "http://freizl.github.com/"
    }

config :: Configuration
config = defaultConfiguration
    --{ deployCommand = "rsync -c -r -ave 'ssh' \
    --                  \_site/* freizl_freizl@ssh.phx.nearlyfreespeech.net:/home/public"
    --}
