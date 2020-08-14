module Main_Parser where


import Common
-- import Text.Parsec.String (parseFromFile)
import Text.Parsec.Error (ParseError)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)

import Parser.SouCParser

{-
parseFromFile :: String -> IO Stmt
parseFromFile file = do
    program  <- readFile file
    case parse undefined  "sup?" program of
        Left e  -> print e >> fail "parse error"
        Right r -> return r

       -}

getFileData :: IO (FilePath, String)
getFileData = getArgs >>= \args -> if length args < 1
    then do
        contents <- getContents
        putStrLn "no file name provided, reading from stdin."
        return ("stdin", contents)
    else let name = head args in do
        contents <- readFile name
        return (name, contents)

outputResult :: FilePath -> Program -> IO ()
outputResult filename (Program name imps body) = do
    putStrLn filename
--     putStr $ (unlines . map show) toks
    putStrLn "------------------ pretty printing ------------------"
    case name of
        Just str -> print $ "importing module: " ++ show str
        Nothing -> return ()
    mapM_ print imps
    mapM_ prettyPrint body
    print_file_contents filename

print_file_contents :: FilePath -> IO ()
print_file_contents filename = do
    putStrLn "-------------------- file contents: --------------------"
    contents <- map ("   "++) . lines <$> readFile filename
    mapM_ putStrLn $ zipWith (++) (map show ([1..]::[Int])) contents


prettyPrint :: Top_Level_Defn -> IO ()
prettyPrint (SubDefn name param (Just (TypeName t)) (Stmts stmts)) = do
    putStr $ "sub " ++ show name ++ " returns (should be IO): " ++ t ++ " takes "
    putStrLn $ show param
    putStrLn (unlines (map prettifyStmt stmts))
prettyPrint (SubDefn name param Nothing (Stmts stmts)) = do
    putStr $ "sub " ++ show name ++ " takes "
    putStrLn $ show param
    putStrLn (unlines (map prettifyStmt stmts))
prettyPrint (FuncDefn name param (Just (TypeName t)) (Stmts stmts)) = do
    putStrLn $ "fn " ++ show name ++ " takn " ++ show param ++ " returns: " ++ t ++ (
                unlines $  (map ((' ':) . prettifyStmt) stmts))
prettyPrint (FuncDefn name param Nothing (Stmts stmts)) = do
    putStrLn $ "fn " ++ show name ++ " takn " ++ show param ++ " " ++ (
                unlines $  (map ((' ':) . prettifyStmt) stmts))
prettyPrint (ShortFuncDefn name param (Just (TypeName t)) expr) = do
    putStrLn $ "fn" ++ show name ++ " takn " ++ show param ++ " returns: " ++ t ++ " = " ++ show expr
prettyPrint (ShortFuncDefn name param Nothing expr) = do
    putStrLn $ "fn" ++ show name ++ " takn " ++ show param ++ " = " ++ show expr
prettyPrint (Top_Level_Const_Defn name (Just type_name) val) = do
    putStrLn $ "const " ++ show name ++ ": " ++ show type_name ++ " = " ++ show val
prettyPrint (Top_Level_Const_Defn name Nothing val) = do
    putStrLn $ "const " ++ show name ++ " = " ++ show val
prettyPrint (MainDefn param (Just (TypeName t)) (Stmts stmts)) = do
    putStrLn $ "fn main with args? " ++ show param ++ " returns (IO?): " ++ t ++ " = "
    putStrLn $ unlines (map ((' ':) . prettifyStmt) stmts)
prettyPrint (MainDefn param Nothing (Stmts stmts)) = do
    putStrLn $ "fn main with args? " ++ show param ++ " = "
    putStrLn $ unlines (map ((' ':) . prettifyStmt) stmts)

prettifyStmt :: Stmt -> String
prettifyStmt stmt = show stmt -- FIXME could be much prettier



main :: IO ()
main = do
    putStrLn "------------------------BEGIN------------------------"
    (filename, input) <- getFileData
    let result = runSouCParser filename input :: Either ParseError Program
    case result of
        Left err -> do
            putStrLn "-------------------- failed parse output:--------------------"
            putStrLn (show err)
            print_file_contents filename
            exitFailure >> return ()
        Right prog -> do
            outputResult filename prog
            exitSuccess >> return ()
