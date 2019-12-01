module Main_Expr where
import Control.Monad (forever)
import System.IO (hFlush, stdout)
import Text.Parsec hiding (space, spaces, string)

import SouC_Expr
import ShuntingYard (run_shunting_yard, print_shunting_yard)
import SouC_Types

{-
main :: IO ()
main = forever $ do
    input <- putStr "> " >> hFlush stdout >> getLine
    putStrLn (run_raw_expr_parser input)
-}


main :: IO ()
main = do
--     putStr "> "
--     hFlush stdout
--     interact (run_new_parse_expr_to_string . Raw_Expr)
--     interact (show . run_shunting_yard)
    print_shunting_yard =<< getContents
    putChar '\n'

{-
run_new_parse_expr_to_string :: Raw_Expr -> String
run_new_parse_expr_to_string re = do
    case run_new_parse_expr re of
        Left err -> "error: " ++ (show err)
        Right tree -> pretty_print_expr_tree tree

pretty_print_expr_tree :: Expr_Tree -> String
pretty_print_expr_tree (Expr_Tree_Inf_Op oper left right) = "(" ++ oper ++ " "  ++ pretty_print_expr_tree left ++ " " ++ pretty_print_expr_tree right ++ ")"
pretty_print_expr_tree (Expr_Tree_Pre_Op oper tree) = "(" ++ oper ++ pretty_print_expr_tree tree ++ ")"
pretty_print_expr_tree (Expr_Tree_Leaf val) = pretty_val val
    where
        pretty_val (Expr_Val_Id ident) = value ident
        pretty_val (Expr_Val_Lit x) = show x

-}
