module SouC_Types where

import Text.Parsec (Parsec)

-- import qualified Data.Map.Strict as Map (Map, singleton, member, insert)
import qualified Data.Map.Strict as Map (Map)

{-
-- the depth and the number of spaces at each level
-- type Indentation = (Int, [Int])
-}
-- for now, indentation must be exactly 4 spaces
type Indentation = Int

type Parser a = Parsec String Indentation a

class Valueable a where
    value :: a -> String

newtype Identifier = Identifier String
                   deriving (Eq, Read, Show)

instance Valueable Identifier where
    value (Identifier v) = v

-- instance Show Identifier where
--     show (Identifier x) = show x

data Program = Program (Maybe ModuleName) Imports Body
    deriving (Read, Show)

newtype ModuleName = ModuleName String deriving (Read, Show)
type Imports = [Import]
type Body = [Top_Level_Defn]

newtype Import = Import String deriving (Read, Show)

type Stmts = [Stmt]

type Param = [Identifier]


data Top_Level_Defn = Top_Level_Const_Defn Identifier Raw_Expr
                    | FuncDefn Identifier Param [Stmt]
                    | ShortFuncDefn Identifier Param Raw_Expr
                    | SubDefn Identifier (Maybe Param) [Stmt]
                    | MainDefn (Maybe Param) [Stmt]
                    deriving (Read, Show)

-- FIXME right now the map maps strings to nothing
type MyState = (Indentation, Map.Map String ())

data Raw_Expr = Raw_Expr String deriving (Read, Show)

instance Valueable Raw_Expr where
    value (Raw_Expr v) = v

data Expr = Expr_Number Integer
          | Expr_CharLit Char
          | Expr_StringLit String
          | Expr_Identifier Identifier
          | Expr_BoolLit Bool -- FIXME generalize this. bools are just like any other `datatype`
          | Expr_FuncCall String Expr
          | Expr_Prefix_Oper String Expr
          | Expr_Infix_Oper Expr String Expr -- FIXME get rid of this?
          deriving (Show)

data Stmt = Stmt_While Raw_Expr Stmts
          | Stmt_If Raw_Expr Stmts (Maybe Stmts)
          | Stmt_Sub_Call Identifier (Maybe Raw_Expr)
          | Stmt_Postfix_Oper Identifier String
          | Stmt_Const_Assign Identifier Raw_Expr
          | Stmt_Var_Assign Identifier Raw_Expr
          | Stmt_Return (Maybe Raw_Expr)
          deriving (Read, Show)

data Endable_Stmts = Stmt_If_End | Stmt_While_End
