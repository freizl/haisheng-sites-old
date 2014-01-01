import           System.IO.Unsafe (unsafePerformIO)
import           System.Directory
import           System.FilePath.Posix
import           Control.Monad

base = "/home/simonwu/github/simple-snap-blog/"
snapletTemplates = base </> "snaplets/heist/templates"

--  base <- getCurrentDirectory
firstLevelTpl :: (FilePath,String) -> Bool
firstLevelTpl (x, y) =  (x `notElem` ["", ".", "..", "layout"])
                        && (y `elem` [".tpl", ""])
                            
                                         

getTemplates1 = liftM (map fst . filter firstLevelTpl . map splitExtension) 
                      (getDirectoryContents snapletTemplates)
getTemplates2 = (getDirectoryContents snapletTemplates) >>= (print . map splitExtension )--filterM doesDirectoryExist >>= print

-- | get all files recursively under a dir.
--   store the first level as categories and all tpl files.
--   
getFilesInDir :: FilePath -> IO [FilePath]
getFilesInDir inp = do
  isDir <- doesDirectoryExist inp
  if isDir then
     (do names <- getDirectoryContents inp
         liftM concat $ forM [ inp </> x | x <- names, isNotSpecialDir x ] getFilesInDir)
     else return [inp]                            

             
-- | is not dir . or ..
isNotSpecialDir :: FilePath -> Bool
isNotSpecialDir x = x `notElem` [".", ".."]


--fetchTplFile :: FilePath -> [FilePath] -> [FilePath]

getTemplates = do
--  base <- getCurrentDirectory
  fs <- getFilesInDir snapletTemplates
  fs2 <- mapM canonicalizePath fs
  print $ map (makeRelative snapletTemplates) fs
  
