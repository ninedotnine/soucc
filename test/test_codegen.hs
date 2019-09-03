-- this test only ensures that *something* is generated for each program tree.
{-# OPTIONS_GHC -Wall #-}

import CodeGen
import SouC_Types

import System.Directory (createDirectoryIfMissing)
import System.Process (callProcess)
-- import System.IO

tmpdir :: FilePath
tmpdir = "/tmp/souc_code_gen_test/"

test :: Program -> String -> IO ()
test prog name = do
    putStr "running test " >> putStr name >> putStr "... "
--     print prog
--     print (generate prog)
    let bin_filename = tmpdir ++ name
        c_filename = bin_filename ++ ".c"
    writeFile c_filename (generate prog)
    callProcess "gcc" [c_filename, "-o", bin_filename]
    putStrLn "OK."

main :: IO ()
main = do
    System.Directory.createDirectoryIfMissing True tmpdir
    putStrLn "=== testing codegen"
    run_tests
    putStrLn "all code gen tests passed :^)"

run_tests :: IO ()
run_tests = do
    test conster "conster"
    test func "func"
    test func2 "func2"
    test mainer "mainer"
    test mainer2 "mainer2"
    test subber "subber"
    test subber_ass "subber_ass"
    test subber_const_ass "subber_const_ass"
    test subber_postfix_oper "subber_postfix_oper"
    test subber_while "subber_while"
    test subber_if "subber_if"
    test subber_if_else "subber_if_else"
    test sub_while "sub_while"

conster :: Program
conster = Program Nothing [] [
    Top_Level_Const_Defn (Identifier "x") (Raw_Expr "42"),
    MainDefn Nothing [
        Stmt_Return (Just (Raw_Expr "0"))]]

func :: Program
func = Program Nothing [] [
    MainDefn Nothing [],
    ShortFuncDefn (Identifier "f") [Identifier "x"] (Raw_Expr "42")]

func2 :: Program
func2 = Program Nothing [] [
    MainDefn Nothing [],
    FuncDefn (Identifier "f") [ Identifier "x"] [
        Stmt_Return (Just (Raw_Expr "42"))]]

mainer :: Program
mainer = Program Nothing [] [MainDefn Nothing [Stmt_Return (Just (Raw_Expr "0"))]]

mainer2 :: Program
mainer2 = Program Nothing [] [MainDefn Nothing []]

subber :: Program
subber = Program Nothing [] [
    MainDefn Nothing [
        Stmt_Sub_Call (Identifier "abort") Nothing]]

subber_ass :: Program
subber_ass = Program Nothing [] [
    MainDefn Nothing [],
    SubDefn (Identifier "subby") Nothing [
        Stmt_Var_Assign (Identifier "x") (Raw_Expr "42")]]

subber_const_ass :: Program
subber_const_ass = Program Nothing [] [
    MainDefn Nothing [],
    SubDefn (Identifier "subby") Nothing [
        Stmt_Const_Assign (Identifier "x") (Raw_Expr "42")]]

subber_postfix_oper :: Program
subber_postfix_oper = Program Nothing [] [
    MainDefn Nothing [],
    SubDefn (Identifier "subby") Nothing [
        Stmt_Var_Assign (Identifier "x") (Raw_Expr "41"),
        Stmt_Postfix_Oper (Identifier "x") "++"]]

subber_while :: Program
subber_while = Program Nothing [] [
    MainDefn Nothing [],
    SubDefn (Identifier "subby") Nothing [
        Stmt_While (Raw_Expr "false") [
            Stmt_Var_Assign (Identifier "x") (Raw_Expr "41"),
            Stmt_Postfix_Oper (Identifier "x") "++"]]]

subber_if :: Program
subber_if = Program Nothing [] [
    MainDefn Nothing [],
    SubDefn (Identifier "subby") Nothing [
        Stmt_If (Raw_Expr "false") [
            Stmt_Var_Assign (Identifier "x") (Raw_Expr "41"),
            Stmt_Postfix_Oper (Identifier "x") "++"]
        Nothing]]

subber_if_else :: Program
subber_if_else = Program Nothing [] [
    SubDefn (Identifier "subby") Nothing [
        Stmt_Var_Assign (Identifier "x") (Raw_Expr "41"),
        Stmt_If (Raw_Expr "false") [
            Stmt_Postfix_Oper (Identifier "x") "++"]
        (Just [
            (Stmt_Postfix_Oper (Identifier "x") "--")])],
    MainDefn Nothing [
        Stmt_Sub_Call (Identifier "subby") Nothing]]

sub_while :: Program
sub_while = Program Nothing [] [
    SubDefn (Identifier "subby") Nothing [
        Stmt_Var_Assign (Identifier "x") (Raw_Expr "41"),
        Stmt_While (Raw_Expr "false") [
            Stmt_Postfix_Oper (Identifier "x") "++"]],
    MainDefn Nothing [
        Stmt_Sub_Call (Identifier "subby") Nothing]]
