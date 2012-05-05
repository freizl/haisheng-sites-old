{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP             #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes  #-}

{-
   templates must follow a kind of scalfold
   check template dir for reference
-}

module Main where

------------------------------------------------------------------------------
import           Control.Exception (SomeException, try)
import           Control.Monad.State
import           Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS
import           Snap.Core
import           Snap.Http.Server
import           Snap.Util.FileServe
import           System.IO
import           System.Directory
import           System.FilePath.Posix
import           Text.Templating.Heist
import           Text.XmlHtml hiding (render)
import           Control.Applicative
import           Data.Maybe (fromMaybe)
import qualified Data.Map as Map
import qualified Data.Text as T
import qualified Data.Text.Encoding as T

#ifdef DEVELOPMENT
import           Snap.Loader.Devel
#else
import           Snap.Loader.Prod
#endif

import Data.Lens.Template
import Snap.Snaplet
import Snap.Snaplet.Heist

------------------------------------------------------------------------------
type TplMap = Map.Map ByteString [String]

data App = App
    { _heist   :: Snaplet (Heist App)
    , _tplmap  :: TplMap -- ^ first level dir and all md under it.
    }

makeLens ''App

instance HasHeist App where
    heistLens = subSnaplet heist

type AppHandler = Handler App App

------------------------------------------------------------------------------

snapletTemplates :: String
snapletTemplates = "snaplets/heist/templates"

-- | find all tpl and directory right under template dir.
isMarkdown :: (FilePath,String) -> Bool
isMarkdown (x, y) = y == ".md" && x /= "index"

firstLevelTpl :: (FilePath,String) -> Bool
firstLevelTpl (_, y) = y == ""

getTemplates1 :: IO [T.Text]
getTemplates1 = do
  base <- getCurrentDirectory
  liftM (map (T.pack . fst) . filter firstLevelTpl . map splitExtension)
        (getDirectoryContents $ base </> snapletTemplates)

getTemplates :: IO TplMap
getTemplates = do
  base <- getCurrentDirectory
  tpldir <- return $ base </> snapletTemplates
  dirs <- liftM (map fst . filter firstLevelTpl . map splitExtension) $ getDirectoryContents tpldir
  liftM Map.fromList $ mapM (getMarkdowns tpldir) dirs
  

getMarkdowns :: String -> String -> IO (ByteString, [String])
getMarkdowns base adir = do
  files <- getDirectoryContents $ base </> adir
  return $ (BS.pack adir, map fst $ filter isMarkdown $  map splitExtension files)


------------------------------------------------------------------------------
  
dirHandler :: Handler App App ()
dirHandler = do
  adir   <- decodedParam "dir"
  post <- decodedParam "post"
  heistLocal (bindSplices $ splices adir post) $ render (adir `BS.append` "/index")  
  where 
    splices :: ByteString -> ByteString -> [(T.Text, Splice AppHandler)]
    splices d p = [ ("mdfile", mdSplices p)
                  , ("tpl-level-2", markdownSplice d)]
    mdSplices :: ByteString -> Splice AppHandler
    mdSplices p = do return $ [TextNode $ T.decodeUtf8 (BS.concat [p,".md"]) ]
  

decodedParam :: MonadSnap m => ByteString -> m ByteString
decodedParam p = fromMaybe "" <$> getParam p


------------------------------------------------------------------------------

templateSplice :: Splice AppHandler
templateSplice = do
  mp <- lift $ gets _tplmap
  mapSplices renderp $ map T.decodeUtf8 $ Map.keys mp
  where
    renderp n = runChildrenWithText $ [("tplname",n)]

markdownSplice :: ByteString -> Splice AppHandler
markdownSplice key = do
  mp <- lift $ gets _tplmap
  --  liftIO $ print $ Map.findWithDefault [] key mp
  mapSplices (renderp key) $ map T.pack $ Map.findWithDefault [] key mp
  where
    renderp k n = runChildrenWithText [("mdname", n), ("mdbase", T.decodeUtf8 k)]


serverVersion :: SnapletSplice b v
serverVersion = liftHeist $ textSplice $ T.decodeUtf8 snapServerVersion

extraSplices :: Initializer App App ()
extraSplices  = do
  addSplices [ ("snap-version", serverVersion) 
             , ("tpl-level-1", liftHeist templateSplice) ]

------------------------------------------------------------------------------

-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes  = [ ("", with heist heistServe)
          , ("", serveDirectory "static")
          ]
          <|>
          [ 
            ("/:dir/:post", dirHandler )           
          ]

-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "heist" heist $ heistInit "templates"
    tmap <- liftIO getTemplates
    addRoutes routes
    extraSplices
    return $ App h tmap


------------------------------------------------------------------------------

main :: IO ()
main = do
    (conf, site, cleanup) <- $(loadSnapTH [| getConf |]
                                          'getActions
                                          ["snaplets/heist/templates"])

    _ <- try $ httpServe conf $ site :: IO (Either SomeException ())
    cleanup

getConf :: IO (Config Snap ())
getConf = commandLineConfig defaultConfig

getActions :: Config Snap () -> IO (Snap (), IO ())
getActions _ = do
    (msgs, site, cleanup) <- runSnaplet app
    hPutStrLn stderr $ T.unpack msgs
    return (site, cleanup)
