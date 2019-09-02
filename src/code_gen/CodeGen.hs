module CodeGen where

import SouC_Types

generate :: Program -> String
-- generate (Program name imports body) =
generate (Program _ _ body) = concat $ map generate_top_level body

generate_top_level :: Top_Level_Defn -> String
generate_top_level (Top_Level_Const_Defn name raw_expr) = "const int " ++ value name ++ " = " ++ value raw_expr ++ ";"
generate_top_level (FuncDefn name param stmts) = "int " ++ value name ++ "(" ++ show param ++ ") {" ++ body ++ "}"
    where body = generate_stmts stmts
generate_top_level (ShortFuncDefn name param raw_expr) = "int " ++ value name ++ "(" ++ show param  ++ ") { return " ++ value raw_expr ++ "; }"
generate_top_level (SubDefn name m_param stmts) = "void " ++ value name ++ "(" ++ param ++ ") { " ++ body ++ "}"
    where
        param = if m_param == Nothing then "void" else show m_param
        body = generate_stmts stmts
generate_top_level (MainDefn m_param stmts) = "int main (" ++ param ++ ") { " ++ body ++ "}"
    where
        param = if m_param == Nothing then "void" else show m_param
        body = generate_stmts stmts

generate_stmts :: Stmts -> String
generate_stmts stmts = concat $ map generate_stmt stmts

generate_stmt :: Stmt -> String
generate_stmt (Stmt_Return m_raw_expr) = "return " ++ raw_expr ++ "; " where
    raw_expr = case m_raw_expr of
        Nothing -> ""
        Just e -> value e
generate_stmt (Stmt_Sub_Call name m_raw_expr) = value name ++ "(" ++ raw_expr ++ "); " where
    raw_expr = case m_raw_expr of
        Nothing -> ""
        Just e -> value e
generate_stmt (Stmt_Var_Assign name raw_expr) = value name ++ " = " ++ value raw_expr ++ "; "
generate_stmt (Stmt_Const_Assign name raw_expr) = "const " ++ value name ++ " = " ++ value raw_expr ++ "; "
generate_stmt (Stmt_Postfix_Oper name oper) = value name ++ oper ++ "; "
generate_stmt (Stmt_While raw_expr stmts) = "while ( " ++ value raw_expr ++ " ) { " ++ generate_stmts stmts ++ "}"
generate_stmt (Stmt_If raw_expr stmts m_else_stmts) = if_branch ++ else_branch m_else_stmts where
    if_branch = "if ( " ++ value raw_expr ++ " ) { " ++ generate_stmts stmts ++ "}"
    else_branch Nothing = ""
    else_branch (Just else_stmts) = " else {" ++ generate_stmts else_stmts ++ "}"
