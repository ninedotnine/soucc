module CodeGen.CodeGen (generate) where

import CodeGen.ExprGen (generate_expr)
import Common (
    Stmt(..),
    Param(..),
    Identifier(..),
    Stmts(..),
    CheckedProgram(..),
    Top_Level_Defn(..)
    )
import Parser.ExprParser

generate :: CheckedProgram -> String
-- generate (Program name imports body) =
generate (CheckedProgram _ _ body) = includes ++ concat (map gen body)
    where includes =
            "#include <stdio.h>\n#include <stdbool.h>\n#include <stdlib.h>\n"

class Generatable a where
    gen :: a -> String

instance Generatable ASTree where
    gen = generate_expr

instance Generatable Identifier where
    gen (Identifier v) = v

instance Generatable Param where
    gen (Param []) = ""
    gen (Param [param]) = "int " ++ gen param -- FIXME
    gen _ = "FIXME LOL"

instance Generatable Top_Level_Defn where
    gen (Top_Level_Const_Defn name expr) =
        "const int " ++ gen name ++ " = " ++ gen expr ++ ";\n"
    gen (FuncDefn name param stmts) =
        "int " ++ gen name ++ "(" ++ gen param ++ ") {" ++ body ++ "}\n"
            where body = gen stmts
    gen (ShortFuncDefn name param expr) =
        "int " ++ gen name ++ "(" ++ gen param  ++ ") { return " ++
        gen expr ++ "; }\n"
    gen (SubDefn name m_param stmts) =
        "void " ++ gen name ++ "(" ++ param ++ ") { " ++ body ++ "}\n" where
            body = gen stmts
            param = case m_param of
                Nothing -> "void"
                Just p -> gen p
    gen (MainDefn m_param stmts) =
        "int main (" ++ param ++ ") { " ++ body ++ "}\n" where
            body = gen stmts
            param = case m_param of
                Nothing -> "void"
                Just p -> gen p

instance Generatable Stmts where
    gen (Stmts stmts) = concat $ map gen stmts

instance Generatable Stmt where
    gen (Stmt_Return m_expr) = "return " ++ expr ++ "; " where
        expr = case m_expr of
            Nothing -> ""
            Just e -> gen e
    gen (Stmt_Sub_Call name m_expr) =
        gen name ++ "(" ++ expr ++ "); " where
            expr = case m_expr of
                Nothing -> ""
                Just e -> gen e
    gen (Stmt_Var_Assign name expr) =
        "int " ++ gen name ++ " = " ++ gen expr ++ "; "
    gen (Stmt_Const_Assign name expr) =
        "const int " ++ gen name ++ " = " ++ gen expr ++ "; "
    gen (Stmt_Postfix_Oper name oper) = gen name ++ oper ++ "; "
    gen (Stmt_While expr stmts) =
        "while ( " ++ gen expr ++ " ) { " ++ gen stmts ++ "} "
    gen (Stmt_Until expr stmts) =
        "while (!( " ++ gen expr ++ " )) { " ++ gen stmts ++ "} "
    gen (Stmt_If expr stmts m_else_stmts) =
        if_branch ++ else_branch m_else_stmts where
            if_branch =
                "if ( " ++ gen expr ++ " ) { " ++ gen stmts ++ "} "
            else_branch Nothing = ""
            else_branch (Just else_stmts) =
                "else {" ++ gen else_stmts ++ "} "
    gen (Stmt_Unless expr stmts m_else_stmts) =
        if_branch ++ else_branch m_else_stmts where
            if_branch =
                "if (!( " ++ gen expr ++ " )) { " ++ gen stmts ++ "} "
            else_branch Nothing = ""
            else_branch (Just else_stmts) =
                "else {" ++ gen else_stmts ++ "} "
